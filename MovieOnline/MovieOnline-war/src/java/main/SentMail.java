/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import com.sun.mail.smtp.SMTPMessage;
import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Date;
import java.util.Properties;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;



/**
 *
 * @author namin
 */
public class SentMail {
    public static void sentFollowMovie(String to,String title,String content,int id) throws UnsupportedEncodingException{
        String body ="<h3>S&E Online</h3><div><p>Your movie <strong style=\"color:blue\">"+title +"</strong> has already upload new episode. Click <a href=\""+content+"/movies?id="+id+"\">here</a> to come to see or click a link below</p><p>"+content+"/movies?id="+id+"</p></div>";
        try {
            Properties props = System.getProperties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.port", "805");
            Session session = Session.getInstance(props,new javax.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication("namintelvn@gmail.com","qjhatrvfskstncgg");
                }
            });
            SMTPMessage msg = new SMTPMessage(session);
            msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
	    msg.addHeader("format", "flowed");
	    msg.addHeader("Content-Transfer-Encoding", "8bit");
            msg.setFrom(new InternetAddress("s&eonline@developer.com", "S&E Online"));
            //msg.setReplyTo(InternetAddress.parse("namintelvn@gmail.com", false));
            msg.setSubject("New Episode Uploaded", "UTF-8");
	    msg.setContent(body, "text/html");
            msg.setSentDate(new Date());
            InternetAddress[] parse = InternetAddress.parse(to , true);
            msg.setRecipients(Message.RecipientType.TO, parse);
            Transport.send(msg);  
        } catch (AddressException e) {
            throw new RuntimeException(e);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
        
    }
}
