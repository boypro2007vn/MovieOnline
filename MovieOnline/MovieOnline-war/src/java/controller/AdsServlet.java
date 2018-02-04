/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author namin
 */
@WebServlet(name="AdsServlet", urlPatterns={"/adsServlet"})
public class AdsServlet extends HttpServlet {
   
    private int getDuration(HttpServletRequest request,String path) throws IOException, InterruptedException {
        int dur =0;
        ProcessBuilder processBuilder = new ProcessBuilder(new String[]{getServletContext().getRealPath("/moviesSource/ffmpeg/bin/ffmpeg.exe"), "-i", path});
        processBuilder.directory(new File(getServletContext().getRealPath("/moviesSource/ads")));
        processBuilder.redirectErrorStream(true);
        Process process = processBuilder.start();
        BufferedReader reader
                = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line;
        while ((line = reader.readLine()) != null) {
            if(line.contains("Duration:")){
                String[] textLine= line.split(",");
                String[] durationS=textLine[0].split(": ");
                String[] time = durationS[1].split(":");
                dur = Integer.parseInt(time[0])*3600 + Integer.parseInt(time[1])*60 + Math.round(Float.parseFloat(time[2]));
            }
        }
        process.waitFor();
        process.destroy();
        reader.close();
        return dur;
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, JSONException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String typeReq = request.getParameter("type");
        if(typeReq == null){
            JSONObject jsonObject = new JSONObject();
            response.setContentType("application/json");
            if (ServletFileUpload.isMultipartContent(request)) {
                try {
                    List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
                    for (FileItem item : multiparts) {
                        if (!item.isFormField()) {
                            File fileVideo = new File(getServletContext().getRealPath("/moviesSource/ads/") + File.separator + item.getName());
                            item.write(fileVideo);
                            File file = new File(getServletContext().getRealPath("/moviesSource/ads/video-list.txt"));
                            String adsName = item.getName();
                            if(file.exists()){
                                try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                                    String sCurrentLine;
                                    if ((sCurrentLine = br.readLine()) != null) {
                                        JSONArray arr = new JSONArray(sCurrentLine);
                                        int duration = getDuration(request,fileVideo.getAbsolutePath());
                                        boolean flag= false;
                                        for(int i = 0;i<arr.length();i++){
                                            JSONObject objChild = arr.getJSONObject(i);
                                            if(objChild.getInt("duration") == duration && objChild.getString("name").equals(adsName)){
                                                flag=true;
                                                jsonObject.put("SUCCESS", "Exist");
                                                out.print(jsonObject);
                                                out.close();
                                                break;
                                            }
                                        }
                                        if(!flag){
                                            JSONObject obj = new JSONObject();
                                            obj.put("name", adsName);
                                            obj.put("duration", duration);
                                            arr.put(obj);
                                            try(FileWriter fileW = new FileWriter(new File(getServletContext().getRealPath("/moviesSource/ads/video-list.txt")))){
                                                fileW.write(arr.toString());
                                                fileW.close();
                                            }
                                            jsonObject.put("SUCCESS", adsName);
                                            jsonObject.put("Duration", duration);
                                            out.print(jsonObject);
                                            out.close();
                                        } 
                                    } 
                                } catch (IOException e) {
                                    throw new Exception("Cannot save file");
                                }
                            }else{
                                jsonObject.put("error", "Cannot find resource file");
                                out.print(jsonObject);
                                out.close();
                            }
                            
                        }
                    }
                } catch (Exception e) {
                    jsonObject.put("error", e.getMessage());
                    out.print(jsonObject);
                    out.close();
                }
            }
        }else{
            if(typeReq.equalsIgnoreCase("saveAds")){
                String arr = request.getParameter("list");
                try {
                    if(arr.length()!=0){
                        try(FileWriter file = new FileWriter(new File(getServletContext().getRealPath("/moviesSource/ads/adslist.txt")))){
                            file.write(arr);
                            file.close();
                        }
                        Cookie[] cookies = request.getCookies();
                        for(Cookie c:cookies){
                            if(c.getName().equalsIgnoreCase("ads-video")){
                                c.setValue(arr);
                                c.setMaxAge(5*60);
                                response.addCookie(c);
                                break;
                            }
                        }
                        out.print("success");
                    }else{
                        throw new Exception("Cannot read list ads");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.print(e.getMessage());
                }
            }
            if(typeReq.equalsIgnoreCase("get")){
                JSONArray arr = new JSONArray();
                JSONArray arr2 = new JSONArray();
                File file = new File(getServletContext().getRealPath("/moviesSource/ads/adslist.txt"));
                File fileVideo = new File(getServletContext().getRealPath("/moviesSource/ads/video-list.txt"));
                boolean error = false;
                if(file.exists()){
                    try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                        String sCurrentLine;
                        if ((sCurrentLine = br.readLine()) != null) {
                            arr = new JSONArray(sCurrentLine);
                        } 
                    } catch (IOException e) {
                        e.printStackTrace();
                        error = true;
                    }
                }
                if(fileVideo.exists()){
                    try (BufferedReader br = new BufferedReader(new FileReader(fileVideo))) {
                        String sCurrentLine;
                        if ((sCurrentLine = br.readLine()) != null) {
                            arr2 = new JSONArray(sCurrentLine);
                        } 
                    } catch (IOException e) {
                        e.printStackTrace();
                        error = true;
                    }
                }
                if(error){
                    request.getRequestDispatcher("admin_page/404.jsp").forward(request, response);
                }else{
                    request.setAttribute("list", arr.toString());
                    request.setAttribute("listVideo", arr2.toString());
                    request.getRequestDispatcher("admin_page/admin_ads.jsp").forward(request, response);
                }
            }
            if(typeReq.equalsIgnoreCase("delVideo")){
                String fileName = request.getParameter("name");
                int duration = Integer.parseInt(request.getParameter("duration"));
                File file = new File(getServletContext().getRealPath("/moviesSource/ads/"+fileName));
                File listVideoF = new File(getServletContext().getRealPath("/moviesSource/ads/video-list.txt"));
                File listTimeline = new File(getServletContext().getRealPath("/moviesSource/ads/adslist.txt"));
                if(file.exists()){
                    try (BufferedReader br = new BufferedReader(new FileReader(listVideoF))) {
                        String sCurrentLine;
                        if ((sCurrentLine = br.readLine()) != null) {
                            JSONArray arr = new JSONArray(sCurrentLine);
                            for(int i=0;i<arr.length();i++){
                                JSONObject obj = arr.getJSONObject(i);
                                if(obj.getString("name").equals(fileName) && obj.getInt("duration")==duration){
                                    arr.remove(i);
                                    break;
                                }
                            }
                            try(FileWriter fileNew = new FileWriter(listVideoF)){
                                fileNew.write(arr.toString());
                                fileNew.close();
                            }
                        } 
                    } catch (IOException e) {
                        e.printStackTrace();
                        out.print(e.getMessage());
                        out.close();
                    }
                    try (BufferedReader br = new BufferedReader(new FileReader(listTimeline))) {
                        String sCurrentLine;
                        if ((sCurrentLine = br.readLine()) != null) {
                            JSONArray arr = new JSONArray(sCurrentLine);
                            JSONArray nArr = new JSONArray();
                            for(int i=0;i<arr.length();i++){
                                JSONObject obj = arr.getJSONObject(i);
                                if(!obj.getString("ad").contains("/"+fileName) && obj.getInt("duration")!=duration){
                                    nArr.put(obj);
                                }
                            }
                            try(FileWriter fileNew = new FileWriter(listTimeline)){
                                fileNew.write(nArr.toString());
                                fileNew.close();
                            }
                            
                        } 
                    } catch (IOException e) {
                        e.printStackTrace();
                        out.print(e.getMessage());
                        out.close();
                    }
                    file.delete();
                    out.print("success");
                    
                }else{
                    out.print("File is not exist");
                    
                }
                out.close();
            }
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JSONException ex) {
            Logger.getLogger(AdsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JSONException ex) {
            Logger.getLogger(AdsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
