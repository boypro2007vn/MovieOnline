/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.EpisodeFacadeLocal;
import bean.NotificationsFacadeLocal;
import entity.Accounts;
import entity.Episode;
import entity.Notifications;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
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
@WebServlet(name = "AdminReUploadServlet", urlPatterns = {"/reuploadMovie"})
public class AdminReUploadServlet extends HttpServlet {
    @EJB
    private NotificationsFacadeLocal notificationsFacade;
    @EJB
    private EpisodeFacadeLocal episodeFacade;
    
    private static LinkedHashMap<Integer, String> resmap = new LinkedHashMap<>();                   
    
    public AdminReUploadServlet(){
        resmap.put(480, "720x480");
        resmap.put(720, "1280x720");
        resmap.put(360, "640x360");
        resmap.put(1080, "1920x1080");;
    }
    private boolean deleteOldFile(Episode curEpi,String mvFolder){
        File folder = new File(getServletContext().getRealPath("/moviesSource/" + "mv_" + mvFolder + "/" + curEpi.getEpisodeName()));
        if(!folder.exists()){
            return true;
        }
        File[] listOfFiles = folder.listFiles();
        try {
            for (int i = 0; i < listOfFiles.length; i++) {
                if (listOfFiles[i].isFile()) {
                    if (listOfFiles[i].getName().contains(curEpi.getEpisodeName() + "_" + curEpi.getLanguage())) {
                        listOfFiles[i].delete();
                    }
                } else if (listOfFiles[i].isDirectory()) {
                    File[] listOfSDFiles = listOfFiles[i].listFiles();
                    for (int j = 0; j < listOfSDFiles.length; j++) {
                        if (listOfSDFiles[j].isFile()) {
                            if (listOfSDFiles[j].getName().contains(curEpi.getEpisodeName() + "_" + curEpi.getLanguage() + "_" + curEpi.getEpisodeId())) {
                                listOfSDFiles[j].delete();
                            }
                        }
                    }
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, JSONException {
        response.setContentType("application/json");
        JSONObject jsonObject = new JSONObject();
        PrintWriter out = response.getWriter();
        String mvFolder ="";
        Episode curEpi = null;
        if (ServletFileUpload.isMultipartContent(request)) {
            try {
                List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
                for (FileItem item : multiparts) {
                    if(item.getFieldName().equals("movieDF")){
                        mvFolder = item.getString();
                    }
                    if(item.getFieldName().equals("episodeId")){
                        curEpi = episodeFacade.find(Integer.parseInt(item.getString()));
                    }
                }
                if(deleteOldFile(curEpi,mvFolder)){
                    for (FileItem item : multiparts) {
                        if (!item.isFormField()) {
                            if(item.getFieldName().equals("reupload-file")){
                                File filebase = new File(getServletContext().getRealPath("/moviesSource/"+"mv_"+mvFolder));
                                if(!filebase.exists()){
                                    filebase.mkdir();
                                }
                                
                                File filevideo = new File(getServletContext().getRealPath("/moviesSource/"+"mv_"+mvFolder+"/"+curEpi.getEpisodeName()));
                                if(!filevideo.exists()){
                                    filevideo.mkdir();
                                }
                                File filevideoHd = new File(getServletContext().getRealPath("/moviesSource/" + "mv_" + mvFolder + "/" + curEpi.getEpisodeName() + "/hd"));
                                if (!filevideoHd.exists()) {
                                    if (!filevideoHd.mkdir()) {
                                        throw new Exception("Cannot create resource folder");
                                    };
                                }
                                File filevideoSd = new File(getServletContext().getRealPath("/moviesSource/" + "mv_" + mvFolder + "/" + curEpi.getEpisodeName() + "/sd"));
                                if (!filevideoSd.exists()) {
                                    if (!filevideoSd.mkdir()) {
                                        throw new Exception("Cannot create resource folder");
                                    };
                                }
                                File filevideoSub = new File(getServletContext().getRealPath("/moviesSource/" + "mv_" + mvFolder + "/" + curEpi.getEpisodeName() + "/sub"));
                                if (!filevideoSub.exists()) {
                                    if (!filevideoSub.mkdir()) {
                                        throw new Exception("Cannot create resource folder");
                                    };
                                }
                                String name = FilenameUtils.removeExtension(item.getName()) + "_" + curEpi.getEpisodeName() + "_" + curEpi.getLanguage() + "." + FilenameUtils.getExtension(item.getName());
                                item.write(new File(filevideo.getAbsolutePath() + File.separator + name));
                                curEpi.setRes360("");
                                curEpi.setRes480("");
                                curEpi.setRes720("");
                                curEpi.setRes1080("");
                                curEpi.setBroken(true);
                                episodeFacade.edit(curEpi);
                                changeRes(getServletContext().getRealPath("/moviesSource/ffmpeg/bin/ffmpeg.exe"), getServletContext().getRealPath("/moviesSource/" + "mv_" + mvFolder + "/" + curEpi.getEpisodeName() + "/"), name, String.valueOf(curEpi.getEpisodeId()),(Accounts)request.getSession().getAttribute("user"));
                                jsonObject.put("SUCCESS", "OK");
                                jsonObject.put("EpisodeID", curEpi.getEpisodeId());
                                out.print(jsonObject);
                                out.close();
                            }else{
                                throw new Exception("Wrong file"); 
                            }
                        }
                    }
                }else{
                    throw new Exception("Cannot delete old resource folder");
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                jsonObject.put("error", "Upload failed. Error: "+e.getMessage());
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
        private Accounts account;
        public MyRunnable(String rPath, String movieFolder, String rEpisodeId, String rFileName,Accounts account) {
            this.rPath = rPath;
            this.movieFolder = movieFolder;
            this.rEpisodeId = rEpisodeId;
            this.rFileName = rFileName;
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
                    Thread.currentThread().interrupt();
                }
            }
        }
    }
    public void changeRes(String path, String mvFolder, String fileLinkName, String episodeId,Accounts account) {
        Thread thread = new Thread(new MyRunnable(path,mvFolder,episodeId,fileLinkName,account));
        thread.start();
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JSONException ex) {
            Logger.getLogger(AdminReUploadServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (JSONException ex) {
            Logger.getLogger(AdminReUploadServlet.class.getName()).log(Level.SEVERE, null, ex);
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
