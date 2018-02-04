/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.AccountsFacadeLocal;
import bean.MoviesFacadeLocal;
import bean.NotificationsFacadeLocal;
import bean.RoleFacadeLocal;
import entity.Accounts;
import entity.Movies;
import entity.Notifications;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.annotation.Resource;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.SystemException;
import javax.transaction.UserTransaction;
import org.apache.commons.io.FileUtils;

/**
 *
 * @author namin
 */
@WebServlet(name = "AdminDeleteMovieServlet", urlPatterns = {"/deleteMovie"})
public class AdminDeleteMovieServlet extends HttpServlet {
    @EJB
    private AccountsFacadeLocal accountsFacade;
    @EJB
    private RoleFacadeLocal roleFacade;
    @EJB
    private NotificationsFacadeLocal notificationsFacade;
    @EJB
    private MoviesFacadeLocal moviesFacade;
    @Resource
    private UserTransaction ut;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, IllegalStateException, SecurityException, SystemException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        int id = 0;
        int userId=0;
        Movies movie =  null;
        boolean result = true;
        try {
            id = Integer.parseInt(request.getParameter("movieId"));
            userId = Integer.parseInt(request.getParameter("user"));
            movie = moviesFacade.find(id);
            if(id ==0 || movie==null){
                result = false;
            }else{
                ut.begin();
                moviesFacade.remove(movie);
                File file = new File(getServletContext().getRealPath("/moviesSource/mv_" + id));
                if (file.exists()) {
                    FileUtils.deleteDirectory(file);
                }
                ut.commit();
            }
        } catch (Exception e) {
            ut.rollback();
            result = false;
        }
        try {
            Notifications noti = new Notifications();
            Accounts acc = accountsFacade.find(userId);
            noti.setSenderID(acc.getAccountId());
            noti.setName(acc.getUserName());
            noti.setEmail(acc.getEmail());
            noti.setRecipientID(0);
            noti.setGroupID(acc.getRole());
            noti.setTitle("TASK");
            noti.setContent("<span style='color:red'>"+acc.getUserName()+"</span> has been delete movie (ID: <span style='color:blue'>"+movie.getMovieId()+"</span> / Name: <span style='color:blue'>"+movie.getRealTitle()+"</span>)");
            noti.setType("SYSTEM-ADMIN");
            noti.setTime(new Timestamp(System.currentTimeMillis()));
            noti.setIsUnread(false);
            notificationsFacade.create(noti);
        } catch (Exception e) {
            result = false;
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
        try {
            processRequest(request, response);
        } catch (IllegalStateException ex) {
            Logger.getLogger(AdminDeleteMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SecurityException ex) {
            Logger.getLogger(AdminDeleteMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SystemException ex) {
            Logger.getLogger(AdminDeleteMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
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
        } catch (IllegalStateException ex) {
            Logger.getLogger(AdminDeleteMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SecurityException ex) {
            Logger.getLogger(AdminDeleteMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SystemException ex) {
            Logger.getLogger(AdminDeleteMovieServlet.class.getName()).log(Level.SEVERE, null, ex);
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
