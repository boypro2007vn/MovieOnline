/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import bean.EpisodeFacadeLocal;
import bean.FavoritesFacadeLocal;
import bean.MoviesFacadeLocal;
import bean.NotificationsFacadeLocal;
import bean.RoleFacadeLocal;
import entity.Accounts;
import entity.Episode;
import entity.Favorites;
import entity.Movies;
import entity.Notifications;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.sql.Timestamp;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Message;
import main.NotiAdminClient;
import main.SentMail;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author namin
 */
@WebServlet(name = "AdminUploadResourceMovieServlet", urlPatterns = {"/adminUploadResourceMovie"})
public class AdminUploadResourceMovieServlet extends HttpServlet {
    @EJB
    private FavoritesFacadeLocal favoritesFacade;
    @EJB
    private NotificationsFacadeLocal notificationsFacade;
    
    @EJB
    private EpisodeFacadeLocal episodeFacade;
    @EJB
    private MoviesFacadeLocal moviesFacade;
    
    private static LinkedHashMap<Integer, String> resmap = new LinkedHashMap<>();                   
    public AdminUploadResourceMovieServlet(){
        resmap.put(480, "720x480");
        resmap.put(720, "1280x720");
        resmap.put(360, "640x360");
        resmap.put(1080, "1920x1080");;
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, JSONException {
        response.setContentType("application/json");
        JSONObject jsonObject = new JSONObject();
        PrintWriter out = response.getWriter();
        
        String mvFolder ="";
        String episodeName="";
        String lang="";
        String fileLinkName ="";
        if (ServletFileUpload.isMultipartContent(request)) {
            try {
                List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
                for (FileItem item : multiparts) {
                    if(item.getFieldName().equals("movieDF")){
                        mvFolder = item.getString();
                    }
                    if(item.getFieldName().equals("episodeName")){
                        float epiNameFloat =0L;
                        try {
                            epiNameFloat = Float.parseFloat(item.getString());
                            if(epiNameFloat != 0){
                                episodeName = String.valueOf(epiNameFloat);
                            }
                        } catch (Exception e) {
                            jsonObject.put("error", "Episode Name is invalid. Please re-enter");
                            out.print(jsonObject);
                            out.close();
                        }
                    }
                    if(item.getFieldName().equals("lang")){
                        lang = item.getString();
                    }
                }
                if(!mvFolder.equals("0") && !mvFolder.isEmpty() && !mvFolder.equals("")){
                    File file = new File(getServletContext().getRealPath("/moviesSource/" + "mv_" + mvFolder));
                    if (!file.exists()) {
                        if (!file.mkdir()) {
                            throw new Exception("Cannot create resource folder");
                        };
                    }
                    for (FileItem item : multiparts) {
                        if (!item.isFormField()) {
                            String name="";
                            if(item.getFieldName().equals("poster-file")){
                                name = "poster.medium." + FilenameUtils.getExtension(item.getName());
                                item.write(new File(file.getAbsolutePath() + File.separator + name));
                                jsonObject.put("SUCCESS", "");
                                out.print(jsonObject);
                                out.close();
                            }
                            if(item.getFieldName().equals("trailer-file")){
                                name = "trailer_"+mvFolder+"."+ FilenameUtils.getExtension(item.getName());
                                Movies movie = moviesFacade.find(Integer.parseInt(mvFolder));
                                movie.setTrailer(name);
                                moviesFacade.edit(movie);
                                item.write(new File(file.getAbsolutePath() + File.separator + name));
                                jsonObject.put("SUCCESS", "");
                                out.print(jsonObject);
                                out.close();
                            }
                            if(item.getFieldName().equals("episode-file")){
                                File file2 = new File(getServletContext().getRealPath("/moviesSource/"+"mv_"+mvFolder+"/"+episodeName));
                                if(!file2.exists()){
                                    if(!file2.mkdir()){
                                        throw new Exception("Cannot create resource folder"); 
                                    };
                                }
                                File file3 = new File(getServletContext().getRealPath("/moviesSource/"+"mv_"+mvFolder+"/"+episodeName+"/hd"));
                                if(!file3.exists()){
                                    if(!file3.mkdir()){
                                        throw new Exception("Cannot create resource folder"); 
                                    };
                                }
                                File file4 = new File(getServletContext().getRealPath("/moviesSource/"+"mv_"+mvFolder+"/"+episodeName+"/sd"));
                                if(!file4.exists()){
                                    if(!file4.mkdir()){
                                        throw new Exception("Cannot create resource folder"); 
                                    };
                                }
                                File file5 = new File(getServletContext().getRealPath("/moviesSource/"+"mv_"+mvFolder+"/"+episodeName+"/sub"));
                                if(!file5.exists()){
                                    if(!file5.mkdir()){
                                        throw new Exception("Cannot create resource folder"); 
                                    };
                                }
                                name = FilenameUtils.removeExtension(item.getName()) + "_" + episodeName + "_" + lang + "." + FilenameUtils.getExtension(item.getName());
                                fileLinkName = name;
                                item.write(new File(file2.getAbsolutePath() + File.separator + name));
                                Episode epi = new Episode();
                                epi.setEpisodeName(Double.parseDouble(episodeName));
                                epi.setMovieId(moviesFacade.find(Integer.parseInt(mvFolder)));
                                epi.setLanguage(lang);
                                epi.setBroken(true);
                                epi.setRes720("");
                                epi.setRes1080("");
                                epi.setRes360("");
                                epi.setRes480("");
                                String sub="";
                                Movies idMovie =moviesFacade.find(Integer.parseInt(mvFolder));
                                List<Episode> updateEpis = episodeFacade.getListByMovieIdandEpisodeName(idMovie, Double.parseDouble(episodeName));
                                if(updateEpis.size()>0){
                                    for(Episode e:updateEpis){
                                        if(e.getSubtitle() !=null && !e.getSubtitle().equals("") && !e.getSubtitle().equals("[]")){
                                            sub = e.getSubtitle();
                                            break;
                                        }
                                    }
                                }
                                epi.setSubtitle(sub);
                                Episode newEpi = episodeFacade.createEpisode(epi);
                                if(newEpi!=null){
                                   String url =request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
                                   changeRes(getServletContext().getRealPath("/moviesSource/ffmpeg/bin/ffmpeg.exe"),getServletContext().getRealPath("/moviesSource/"+"mv_"+mvFolder+"/"+episodeName+"/"), fileLinkName, String.valueOf(newEpi.getEpisodeId()),idMovie,url,(Accounts)request.getSession().getAttribute("user"));
                                   jsonObject.put("SUCCESS", "OK");
                                   jsonObject.put("episodeId", newEpi.getEpisodeId());
                                   jsonObject.put("episodeName", newEpi.getEpisodeName());
                                   jsonObject.put("lang", newEpi.getLanguage());
                                   jsonObject.put("filename", fileLinkName);
                                   out.print(jsonObject);
                                   out.close();
                                }else{
                                    jsonObject.put("error", "Cannot create episode");
                                    out.print(jsonObject);
                                    out.close();
                                }
                            }

                        }
                        
                    }      
                }else{
                    jsonObject.put("error", "Cannot find resource folder");
                    out.print(jsonObject);
                    out.close();
                    throw new Exception("Cannot find resource folder"); 
                }
            } catch (Exception e) {
                jsonObject.put("error", "Upload failed. Something wrong");
                out.print(jsonObject);
                out.close();
            }
        }
    }
    public class MyRunnable implements Runnable {
        private String rPath;
        private String movieFolder;
        private String rEpisodeId;
        private String rFileName;
        private String[] cmdArray;
        private Movies movieID;
        private String url;
        private Accounts account;
        public MyRunnable(String rPath, String movieFolder, String rEpisodeId, String rFileName,Movies movieID,String url,Accounts account) {
            this.rPath = rPath;
            this.movieFolder = movieFolder;
            this.rEpisodeId = rEpisodeId;
            this.rFileName = rFileName;
            this.movieID = movieID;
            this.url = url;
            this.account = account;
        }
        
        
        public void run(){
            while (!Thread.currentThread().isInterrupted()) {
                try {
                    String epi360Name = "";
                    String epi480Name = "";
                    String epi720Name = "";
                    String epi1080Name = "";
                    String[] newFilename = new String[]{rFileName.substring(0, rFileName.lastIndexOf(".")), rFileName.substring(rFileName.lastIndexOf(".") + 1)};
                    for (Map.Entry<Integer, String> entry : resmap.entrySet()) {
                        int key = entry.getKey();
                        if (key == 1080) {
                            epi1080Name = newFilename[0] + "_" + rEpisodeId + "_1080.m3u8";
                            String epi1080 = movieFolder + File.separator + "hd" + File.separator + epi1080Name;
                            cmdArray = new String[]{rPath, "-i", rFileName, "-profile:v", "baseline", "-level", "3.0", "-s", entry.getValue(), "-start_number", "0", "-hls_time", "10", "-hls_list_size", "0", "-f", "hls", epi1080};
                        }
                        if (key == 720) {
                            epi720Name = newFilename[0] + "_" + rEpisodeId + "_720.m3u8";
                            String epi720 = movieFolder + File.separator + "hd" + File.separator + epi720Name;
                            cmdArray = new String[]{rPath, "-i", rFileName, "-profile:v", "baseline", "-level", "3.0", "-s", entry.getValue(), "-start_number", "0", "-hls_time", "10", "-hls_list_size", "0", "-f", "hls", epi720};
                        }
                        if (key == 480) {
                            epi480Name = newFilename[0] + "_" + rEpisodeId + "_480." + newFilename[1];
                            String epi480 = movieFolder + File.separator + "sd" + File.separator + epi480Name;
                            cmdArray = new String[]{rPath, "-i", rFileName, "-vf", "scale=" + entry.getValue(), epi480};
                        }
                        if (key == 360) {
                            epi360Name = newFilename[0] + "_" + rEpisodeId + "_360." + newFilename[1];
                            String epi360 = movieFolder + File.separator + "sd" + File.separator + epi360Name;
                            cmdArray = new String[]{rPath, "-i", rFileName, "-vf", "scale=" + entry.getValue(), epi360};
                        }
                        ProcessBuilder processBuilder = new ProcessBuilder(cmdArray);
                        processBuilder.directory(new File(movieFolder));
                        processBuilder.redirectErrorStream(true);
                        Process process = processBuilder.start();
                        BufferedReader reader
                                = new BufferedReader(new InputStreamReader(process.getInputStream()));
                        while ((reader.readLine()) != null) {
                        }
                        process.waitFor();
                        process.destroy();
                        Episode newEpi = episodeFacade.find(Integer.parseInt(rEpisodeId));
                        if (newEpi != null) {
                            newEpi.setRes360(epi360Name);
                            newEpi.setRes480(epi480Name);
                            newEpi.setRes720(epi720Name);
                            newEpi.setRes1080(epi1080Name);
                            newEpi.setBroken(false);
                            episodeFacade.edit(newEpi);
                        }
                        if (newEpi != null && !newEpi.getRes360().equals("") && !newEpi.getRes480().equals("") && !newEpi.getRes720().equals("") && !newEpi.getRes1080().equals("")) {
                            NotiAdminClient noti = new NotiAdminClient();
                            Thread.sleep(10000);
                            Message msg = new Message();
                            msg.setSubject("changeRes");
                            msg.setContent("Process render resolution : (EpisodeID: <span class='text-primary'>" + newEpi.getEpisodeId() + "</span> | Episode Name: <span class='text-primary'>" + newEpi.getEpisodeName() + " </span>) of movie <span class='text-primary'>" + newEpi.getMovieId().getRealTitle() + "</span> has been complete;" + newEpi.getEpisodeId());
                            noti.sendMessage(msg);
                            Notifications notiDB = new Notifications();
                            if (account != null && (account.getRole().getName().equalsIgnoreCase("ROLE_ADMIN") || account.getRole().getName().equalsIgnoreCase("ROLE_UPLOADER"))) {
                                notiDB.setSenderID(account.getAccountId());
                                notiDB.setName(account.getUserName());
                                notiDB.setEmail(account.getEmail());
                                notiDB.setRecipientID(0);
                                notiDB.setGroupID(account.getRole());
                                notiDB.setTitle("TASK");
                                notiDB.setContent("Process render resolution : (EpisodeID: <span class='text-primary'>" + newEpi.getEpisodeId() + "</span> | Episode Name: <span class='text-primary'>" + newEpi.getEpisodeName() + " </span>) of movie <span class='text-primary'>" + newEpi.getMovieId().getRealTitle() + "</span> has been complete");
                                notiDB.setType("SYSTEM-ADMIN");
                                notiDB.setTime(new Timestamp(System.currentTimeMillis()));
                                notiDB.setIsUnread(false);
                                notificationsFacade.create(notiDB);
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    Thread.currentThread().interrupt();
                } finally {
                    List<Episode> listE = episodeFacade.getListByMovieIdandEpisodeName(movieID,episodeFacade.find(Integer.parseInt(rEpisodeId)).getEpisodeName());
                    if(listE.size()==1){
                        List<Favorites> list = favoritesFacade.getListByFollowandMovie(true, movieID);
                        if(list.size()!=0){
                            String to="";
                            for(Favorites fav :list){
                                to+=fav.getAccountId().getEmail()+",";
                            }
                            try {
                                SentMail.sentFollowMovie(to, movieID.getTitle(), url, movieID.getMovieId());
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }
                    Thread.currentThread().interrupt();
                    
                }
            }
        }
    }
    
    public void changeRes(String path, String mvFolder, String fileLinkName, String episodeId,Movies movieID,String url,Accounts account) {
        Thread thread = new Thread(new MyRunnable(path,mvFolder,episodeId,fileLinkName,movieID,url,account));
        thread.start();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JSONException ex) {
            Logger.getLogger(AdminUploadResourceMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JSONException ex) {
            Logger.getLogger(AdminUploadResourceMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
