package com.querodoar.querodoar_api.usuario;

import com.querodoar.querodoar_api.config.DefaultMediaInitializer;
import com.querodoar.querodoar_api.exceptions.UnauthorizedException;
import com.querodoar.querodoar_api.usuario.dtos.UserCreateDto;
import com.querodoar.querodoar_api.usuario.dtos.UserUpdateDto;
import com.querodoar.querodoar_api.utils.ImageProcessor;
import com.querodoar.querodoar_api.utils.StringUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/user")
@Tag(name = "Usuário", description = "Operações relacionadas aos usuários do sistema")
public class UserController {
    @Autowired
    private UserService service;

    @Value("${file.media.user.path:./media/user/}")
    private String userPhotoPath;

    @Operation(summary = "Lista todos os usuários")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Lista retornada com sucesso"),
            @ApiResponse(responseCode = "401", description = "Não autorizado")
    })
    @GetMapping
    public ResponseEntity<Page<User>> getAll(Pageable pageable){
        Page<User> usuarios = this.service.getAll(pageable);
        return new ResponseEntity<>(usuarios, HttpStatus.OK);
    }

    @Operation(summary = "Cria um novo usuário, rota disponivel apenas para usuarios administrativos")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "Usuário criado com sucesso"),
        @ApiResponse(responseCode = "400", description = "Dados inválidos"),
        @ApiResponse(responseCode = "409", description = "Email ou CPF já cadastrado")
    })
    @PostMapping("/create")
    public ResponseEntity<User> create(@Valid @RequestBody UserCreateDto dto, Authentication auth) {
        Integer usuarioId = (Integer) auth.getPrincipal();
        User usuarioLogado = service.findById(usuarioId);
        if(usuarioLogado.getRole() != Role.ADMIN)
            throw new UnauthorizedException("Acesso negado: apenas administradores podem criar usuários");

        User usuario = this.service.create(dto, usuarioId);
        return new ResponseEntity<>(usuario, HttpStatus.CREATED);
    }

    @Operation(summary  = "Delete de usuarios por id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Usuario deletado com sucesso"),
            @ApiResponse(responseCode = "401", description = "Não autorizado")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<HttpStatus> delete(@PathVariable int id, Authentication auth){
        Integer usuarioId     = (Integer) auth.getPrincipal();
        User usuarioLogado = service.findById(usuarioId);
        if(usuarioLogado.getRole() != Role.ADMIN)
            throw new UnauthorizedException("Acesso negado: apenas administradores podem deletar usuários");

        this.service.delete(id, usuarioLogado);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Operation(summary = "Atualiza um usuario por id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Atualizado com sucesso"),
            @ApiResponse(responseCode = "401", description = "Não autorizado")
    })
    @PatchMapping("/{id}")
    public ResponseEntity<User> update(@PathVariable Integer id, @Valid @RequestBody UserUpdateDto dto, Authentication auth){
        Integer usuarioId = (Integer) auth.getPrincipal();
        User usuario      = this.service.update(id, dto, usuarioId);
        return new ResponseEntity<>(usuario, HttpStatus.OK);
    }

    @Operation(summary = "Faz o upload de uma foto de perfil do usuário")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Upload realizado com sucesso"),
            @ApiResponse(responseCode = "400", description = "Erro no upload da imagem"),
            @ApiResponse(responseCode = "401", description = "Não autorizado")
    })
    @PostMapping(value = "/photo", consumes = "multipart/form-data")
    public ResponseEntity<?> uploadPhoto(
            @Parameter(description = "Arquivo de imagem (JPG ou PNG)", required = true, content = @Content(mediaType = "multipart/form-data"))
            @RequestParam("file") MultipartFile file,
            @Parameter(description = "Coordenada X do recorte (junto com Y forma o ponto superior esquerdo do recorte)", required = true)
            @RequestParam("x") int x,
            @Parameter(description = "Coordenada Y do recorte (junto com X forma o ponto superior esquerdo do recorte)", required = true)
            @RequestParam("y") int y,
            @Parameter(description = "Largura do recorte", required = true)
            @RequestParam("width") int width,
            @Parameter(description = "Altura do recorte", required = true)
            @RequestParam("height") int height,
            Authentication auth) {
        try {

            String contentType = file.getContentType();
            if (!"image/jpeg".equals(contentType) && !"image/png".equals(contentType)) {
                return ResponseEntity.status(HttpStatus.UNSUPPORTED_MEDIA_TYPE)
                        .body("Formato de arquivo não suportado. Apenas JPEG e PNG são aceitos.");
            }

            Integer userId = (Integer) auth.getPrincipal();

            File inputFile = File.createTempFile("usr_photo_input_", file.getOriginalFilename());
            file.transferTo(inputFile);

            String fileName = StringUtil.generateStringFromSeed(userId.toString(), 30, null) + ".webp";
            File outputFile = new File(userPhotoPath + fileName);

            ImageProcessor.processImage(inputFile, outputFile, x, y, width, height, 360, 360);

            UserUpdateDto dto = new UserUpdateDto();
            dto.setPhoto(fileName);
            service.update(userId, dto, userId);

            inputFile.delete();

            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Erro ao processar a imagem: " + e.getMessage());
        }
    }

    @Operation(summary = "Remove a foto de perfil do usuário")
    @DeleteMapping("/photo")
    public ResponseEntity<?> deletePhoto(Authentication auth) {
        Integer userId = (Integer) auth.getPrincipal();
        User user = service.findById(userId);
        if (user.getPhoto() != null && !user.getPhoto().isEmpty()) {
            File photoFile = new File(userPhotoPath + user.getPhoto());
            if (photoFile.exists()) {
                if (!photoFile.delete()) {
                    Logger logger = LoggerFactory.getLogger(UserController.class);
                    logger.warn("Não foi possível deletar o arquivo de foto: " + photoFile.getAbsolutePath());
                }
            }
            UserUpdateDto dto = new UserUpdateDto();
            dto.setPhoto("");
            service.update(userId, dto, userId);
        }

        return ResponseEntity.ok().build();
    }
}
