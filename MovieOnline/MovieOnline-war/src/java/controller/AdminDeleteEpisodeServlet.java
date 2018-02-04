/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.EpisodeFacadeLocal;
import bean.NotificationsFacadeLocal;
import com.google.gson.JsonArray;
import entity.Accounts;
import entity.Episode;
import entity.Notifications;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author namin
 */
@WebServlet(name = "AdminDeleteEpisodeServlet", urlPatterns = {"/deleteEpisode"})
public class AdminDeleteEpisodeServlet extends HttpServlet {
    @EJB
    private NotificationsFacadeLocal notificationsFacade;
    @EJB
    private EpisodeFacadeLocal episodeFacade;

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String result = "false";
        int id = 0;
        try {
            id = Integer.parseInt(request.getParameter("episodeId"));
            if(id != 0){
               Episode epi = episodeFacade.find(id);
               String movieForder = request.getParameter("movieFolder");
               String episodeName = request.getParameter("episodeName");
               File folder = new File(getServletContext().getRealPath("/moviesSource/"+"mv_"+movieForder+"/"+episodeName));
               if(folder.exists()){
                   File[] listOfFiles = folder.listFiles();
                   for (int i = 0; i < listOfFiles.length; i++) {
                       if (listOfFiles[i].isFile()) {
                           if (listOfFiles[i].getName().contains(episodeName + "_" + epi.getLanguage())) {
                               listOfFiles[i].delete();
                           }
                       } else if (listOfFiles[i].isDirectory()) {
                           File[] listOfSDFiles = listOfFiles[i].listFiles();
                           for (int j = 0; j < listOfSDFiles.length; j++) {
                               if (listOfSDFiles[j].isFile()) {
                                   if (listOfSDFiles[j].getName().contains(episodeName + "_" + epi.getLanguage() + "_" + epi.getEpisodeId())) {
                                       listOfSDFiles[j].delete();
                                   }
                               }
                           }
                       }
                   }
               }
                Episode epiDel = episodeFacade.find(id);
                episodeFacade.remove(epiDel);
                Notifications noti = new Notifications();
                Accounts acc = (Accounts)request.getSession().getAttribute("user");
                noti.setSenderID(acc.getAccountId());
                noti.setName(acc.getUserName());
                noti.setEmail(acc.getEmail());
                noti.setRecipientID(0);
                noti.setGroupID(acc.getRole());
                noti.setTitle("TASK");
                noti.setContent("<span style='color:red'>"+acc.getUserName()+"</span> has been delete episode (ID: <span style='color:blue'>"+epiDel.getEpisodeId()+"</span>) of movie <span style='color:blue'>"+epiDel.getMovieId().getRealTitle()+"</span>)");
                noti.setType("SYSTEM-ADMIN");
                noti.setTime(new Timestamp(System.currentTimeMillis()));
                noti.setIsUnread(false);
                notificationsFacade.create(noti);
               result = "true";
            }
        } catch (Exception e) {
            result = "false";
        }
        out.print(result);
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
        processRequest(request, response);
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
        processRequest(request, response);
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
