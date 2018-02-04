/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package main;

import java.util.HashMap;
import java.util.LinkedHashMap;

/**
 *
 * @author namin
 */

public class Common {
    public static LinkedHashMap<String,Integer> ratingList;
    public static LinkedHashMap<String,Integer> getRatingList(){
        ratingList = new LinkedHashMap<>();
        ratingList.put("1/10", 0);
        ratingList.put("2/10", 0);
        ratingList.put("3/10", 0);
        ratingList.put("4/10", 0);
        ratingList.put("5/10", 0);
        ratingList.put("6/10", 0);
        ratingList.put("7/10", 0);
        ratingList.put("8/10", 0);
        ratingList.put("9/10", 0);
        ratingList.put("10/10", 0);
        return ratingList;
    }
    
    
}
