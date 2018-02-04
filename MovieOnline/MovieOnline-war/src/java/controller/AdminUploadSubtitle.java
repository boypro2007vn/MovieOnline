/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.EpisodeFacadeLocal;
import bean.MoviesFacadeLocal;
import com.google.gson.Gson;
import entity.Episode;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author namin
 */
@WebServlet(name="AdminUploadSubtitle", urlPatterns={"/adminUploadSubtitle"})
public class AdminUploadSubtitle extends HttpServlet {
    @EJB
    private MoviesFacadeLocal moviesFacade;
    @EJB
    private EpisodeFacadeLocal episodeFacade;
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, JSONException {
        response.setContentType("application/json");
        JSONObject jsonObject = new JSONObject();
        PrintWriter out = response.getWriter();
        String type = request.getParameter("type");
        if(type == null){
            String mvFolder ="";
            JsonArrayBuilder listSubBuilder = Json.createArrayBuilder();
            double episodeName=0;
            if (ServletFileUpload.isMultipartContent(request)) {
                try {
                    List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
                    for (FileItem item : multiparts) {
                        if(item.getFieldName().equals("movieDF")){
                            mvFolder = item.getString();
                        }
                        if(item.getFieldName().equals("episodeName")){
                            try {
                                episodeName = Double.parseDouble(item.getString());
                            } catch (Exception e) {
                                jsonObject.put("error", "Episode Name is invalid.");
                                out.print(jsonObject);
                                out.close();
                            }
                        }
                    }
                    if(!mvFolder.equals("0") && !mvFolder.isEmpty() && !mvFolder.equals("")){
                        File file5 = new File(getServletContext().getRealPath("/moviesSource/" + "mv_" + mvFolder + "/" + episodeName + "/sub"));
                        if (!file5.exists()) {
                            if (!file5.mkdir()) {
                                throw new Exception("Cannot create resource folder");
                            };
                        }
                        for (FileItem item : multiparts) {
                            if (!item.isFormField()) {
                                if (FilenameUtils.getExtension(item.getName()).equalsIgnoreCase("vtt")) {
                                    String[] subs = FilenameUtils.removeExtension(item.getName()).split("_");
                                    if (subs.length != 3) {
                                        jsonObject.put("error", "Wrong format subtitle. EX: spiderman_en_English.vtt");
                                        out.print(jsonObject);
                                        out.close();
                                        throw new Exception("Wrong format sub name");
                                    } else {
                                        JsonObjectBuilder jsonSubObg = Json.createObjectBuilder()
                                                .add("name", item.getName())
                                                .add("code", subs[1])
                                                .add("lang", subs[2]);
                                        listSubBuilder.add(jsonSubObg);
                                        item.write(new File(file5.getAbsolutePath() + File.separator + item.getName()));
                                    }

                                }
                            }
                        }
                        List<Episode> updateEpis = episodeFacade.getListByMovieIdandEpisodeName(moviesFacade.find(Integer.parseInt(mvFolder)), episodeName);
                        for(Episode epi:updateEpis){
                            String currentEpi = epi.getSubtitle();
                            if(!currentEpi.isEmpty() && !currentEpi.equals("[]") && currentEpi != null){
                                JSONArray array = new JSONArray(currentEpi);
                                for (int i=0; i < array.length(); i++) {
                                    if(!listSubBuilder.build().toString().contains(array.getJSONObject(i).getString("name"))){
                                        JsonObjectBuilder jsonSubObg = Json.createObjectBuilder()
                                                    .add("name", array.getJSONObject(i).getString("name"))
                                                    .add("code", array.getJSONObject(i).getString("code"))
                                                    .add("lang", array.getJSONObject(i).getString("lang"));
                                        listSubBuilder.add(jsonSubObg);
                                    } 
                                }
                            }
                            JsonArray jsonArray = listSubBuilder.build();
                            if (jsonArray.size()!= 0) {
                                epi.setSubtitle(jsonArray.toString());
                                episodeFacade.edit(epi);
                            }
                        }
                        jsonObject.put("SUCCESS", "OK");
                        out.print(jsonObject);
                        out.close();
                    }else{
                        jsonObject.put("error", "Cannot find resource folder");
                        out.print(jsonObject);
                        out.close();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    jsonObject.put("error", "Upload failed. Something wrong");
                    out.print(jsonObject);
                    out.close();
                }
            }
        }else{
            int movieId = Integer.parseInt(request.getParameter("movieID"));
            if(type.equalsIgnoreCase("getListEpisode")){
                List<String> listEpiName = episodeFacade.getListEpisodeByMovieIdGroupByEpisodeName(moviesFacade.find(movieId));
                if(listEpiName.size()==0){
                    jsonObject.put("result","Cannot get list episode name");
                    out.print(jsonObject);
                    out.close();
                }else{
                    jsonObject.put("result", "success");
                    jsonObject.put("list", new Gson().toJson(listEpiName).toString());
                    out.print(jsonObject);
                    out.close();
                }
            }else{
                double episodeName = Double.parseDouble(request.getParameter("episodeName"));
                String fileName = request.getParameter("fileName");
                try {
                    List<Episode> updateEpis = episodeFacade.getListByMovieIdandEpisodeName(moviesFacade.find(movieId), episodeName);
                    for(Episode epi:updateEpis){
                        String subs = epi.getSubtitle();
                        if(!subs.equals("") && subs !=null){
                            List<String> listSub = new ArrayList<String>(); 
                            JSONArray jsonArray = new JSONArray(subs);
                            if(jsonArray.length() !=0){
                                JSONObject obj;
                                for (int i=0;i<jsonArray.length();i++){
                                    obj = jsonArray.getJSONObject(i);
                                    if(!obj.getString("name").equals(fileName)){
                                        listSub.add(jsonArray.get(i).toString());
                                    }
                                }
                                epi.setSubtitle(listSub.toString());
                                episodeFacade.edit(epi);
                            }
                        }
                    }
                    File fileSub = new File(getServletContext().getRealPath("/moviesSource/mv_"+movieId+"/"+String.valueOf(episodeName)+"/sub/"+fileName));
                    if(fileSub.exists()){
                        fileSub.delete();
                    }
                    jsonObject.put("result", "success");
                    out.print(jsonObject);
                    out.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    jsonObject.put("result", "Cannot delete sub. Error: "+e.getMessage());
                    out.print(jsonObject);
                    out.close();
                }
                
                
            }
        } 
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JSONException ex) {
            Logger.getLogger(AdminUploadSubtitle.class.getName()).log(Level.SEVERE, null, ex);
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JSONException ex) {
            Logger.getLogger(AdminUploadSubtitle.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
