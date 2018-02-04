/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package main;

import java.text.DateFormat;
import java.text.Normalizer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author namin
 */
public class Check {
    static Pattern pat;
    static Matcher mat;
    
    //xoa khoang trang thua
    public static String removeSpace(String text){
        return text.replaceAll("^ +| +$|( )+", "$1");
    }
    
    //ten fim
    public static boolean checkFullname(String name){
        pat = Pattern.compile("^[\\w\\s\\-\\.]+$");
        mat = pat.matcher(name);
        return mat.matches();
    }
    
    //ten la a-z
    public static boolean checkName(String name){
        pat = Pattern.compile("^[a-zA-Z\\s]+$");
        mat = pat.matcher(name);
        return mat.matches();
    }
    
    //check username password
    public static boolean checkAccount(String name){
        pat = Pattern.compile("^[a-zA-Z]{6,20}$");
        mat = pat.matcher(name);
        return mat.matches();
    }
    
    public static boolean checkEmail(String email){
        pat = Pattern.compile("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
        mat = pat.matcher(email);
        return mat.matches();
    }
    
    public static boolean checkPhone(String phone){
        pat = Pattern.compile("^(((\\d-)?\\d{3}-)?(\\d{3}-\\d{4})|\\d{7}|\\d{10,11})$");
        mat = pat.matcher(phone);
        return mat.matches();
    }
    
    public static boolean checkHDUrl(String url){
        pat = Pattern.compile("\\/moviesSource\\/[0-9]+\\/hd\\/.+\\.m3u8$");
        mat = pat.matcher(url);
        return mat.matches();
    }
    
    public static String convertDay(String day) throws ParseException{
        DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
        DateFormat df2 = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate;
        String newDateString;
        try {
            startDate = df.parse(day);
            newDateString = df2.format(startDate);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
        return newDateString;
    }
    
    public static String convertDay2(String day) throws ParseException{
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        DateFormat df2 = new SimpleDateFormat("MM/dd/yyyy");
        Date startDate;
        String newDateString;
        try {
            startDate = df.parse(day);
            newDateString = df2.format(startDate);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
        return newDateString;
    }
    
    //xoa dau , price
    public static String removeComma(String text){
        return text.replaceAll(",", ""); 
    }
    public static String removeAccent(String s) {
        String temp = Normalizer.normalize(s, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(temp).replaceAll("");
    }
    public static boolean checkUrl(String url){
        pat = Pattern.compile("\\b(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]");
        mat = pat.matcher(url);
        return mat.matches();
    }
}
