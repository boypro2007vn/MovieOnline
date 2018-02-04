/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package main;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import javax.xml.bind.DatatypeConverter;

/**
 *
 * @author namin
 */
public class Encrypt {   
    
    //random = true: tao chuoi ma hoa ngau nhien
    public static String encrypt(String password,boolean random) throws NoSuchAlgorithmException{
        String generatedPassword = null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            if(random){
                md.update(getSalt());
            }
            byte[] bytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for(int i=0;i<bytes.length;i++){
                sb.append(Integer.toString((bytes[i] & 0xff)+0x100,16).substring(1));
            }
            generatedPassword = sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedPassword;
    }
    
    
    private static byte[] getSalt() throws NoSuchAlgorithmException{
        SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
        byte[] salt = new byte[16];
        sr.nextBytes(salt);
        return salt;
    }
    
    public static String encryptBASE64(String str){
//        byte[] encodedBytes;
//        try {
//            encodedBytes = Base64.getEncoder().encode(str.getBytes());
//        } catch (Exception e) {
//            return null;
//        }
//        return new String(encodedBytes); for jdk 1.8
        String encodedBytes ="";
        try {
            encodedBytes = DatatypeConverter.printBase64Binary(str.getBytes());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return encodedBytes;
    }
    
    public static String decryptBASE64(String str) throws UnsupportedEncodingException{
//        byte[] encodedBytes;
//        try {
//            encodedBytes = Base64.getDecoder().decode(str);
//        } catch (Exception e) {
//            return null;
//        }
//        return new String(encodedBytes); for jdk 1.8
        byte[] encodedBytes= new byte[100];
        try {
            encodedBytes = DatatypeConverter.parseBase64Binary(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new String(encodedBytes,"UTF-8");
    }
}
