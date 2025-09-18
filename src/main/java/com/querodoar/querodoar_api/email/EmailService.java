package com.querodoar.querodoar_api.email;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Value("${app.mail.sender}")
    private String senderEmail;

    @Value("${app.frontend.url}")
    private String frontendUrl;

    public void sendVerificationEmail(String to, String token) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
        helper.setFrom(senderEmail);
        helper.setTo(to);
        helper.setSubject("Ativação de Conta - Quero Doar");
        String verificationLink = frontendUrl + "/verify?token=" + token + "&email=" + to;
        String htmlContent = "<p>Obrigado por se registrar no Quero Doar!</p>" +
                "<p>Por favor, clique no link abaixo para ativar sua conta:</p>" +
                "<a href=\"" + verificationLink + "\">Ativar Conta</a>" +
                "<p>Se você não se registrou, por favor ignore este e-mail.</p>";
        helper.setText(htmlContent, true);
        mailSender.send(message);
    }


}
