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

    public void sendNoticeAccountActivated(String to) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
        helper.setFrom(senderEmail);
        helper.setTo(to);
        helper.setSubject("Conta Ativada - Quero Doar");
        String htmlContent = "<p>Sua conta no Quero Doar foi ativada com sucesso!</p>" +
                "<p>Agora você pode fazer login e começar a usar nossos serviços.</p>";
        helper.setText(htmlContent, true);
        mailSender.send(message);
    }

    public void sendRecoveryPasswordEmail(String to, String token) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
        helper.setFrom(senderEmail);
        helper.setTo(to);
        helper.setSubject("Recuperação de Senha - Quero Doar");
        String recoveryLink = frontendUrl + "/password-recovery?token=" + token + "&email=" + to;
        String htmlContent = "<p>Recebemos uma solicitação para redefinir sua senha no Quero Doar.</p>" +
                "<p>Por favor, clique no link abaixo para redefinir sua senha:</p>" +
                "<a href=\"" + recoveryLink + "\">Redefinir Senha</a>" +
                "<p>Se você não solicitou a redefinição de senha, por favor ignore este e-mail.</p>";
        helper.setText(htmlContent, true);
        mailSender.send(message);
    }

    public void sendNoticePasswordChanged(String to) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
        helper.setFrom(senderEmail);
        helper.setTo(to);
        helper.setSubject("Senha Alterada - Quero Doar");
        String htmlContent = "<p>Sua senha foi alterada com sucesso.</p>" +
                "<p>Se você não realizou essa alteração, por favor entre em contato conosco imediatamente.</p>";
        helper.setText(htmlContent, true);
        mailSender.send(message);
    }
}
