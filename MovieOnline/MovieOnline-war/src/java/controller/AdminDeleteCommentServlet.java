/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import bean.AccountsFacadeLocal;
import bean.CommentsFacadeLocal;
import bean.NotificationsFacadeLocal;
import entity.Accounts;
import entity.Comments;
import entity.Notifications;
import java.io.IOException;
import java.io.PrintWriter;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminDeleteCommentServlet", urlPatterns = {"/AdminDeleteComment"})
public class AdminDeleteCommentServlet extends HttpServlet {

    @EJB
    private NotificationsFacadeLocal notificationsFacade;
    @EJB
    private AccountsFacadeLocal accountsFacade;
    @EJB
    private CommentsFacadeLocal commentsFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String condition = request.getParameter("condition");
        switch (condition) {
            case "deleteComment": {
                int commentId = Integer.parseInt(request.getParameter("commentId"));
                Comments comment = commentsFacade.find(commentId);
                int notiId = Integer.parseInt(request.getParameter("notiId"));
                try {
                    commentsFacade.remove(comment);
                    Notifications noti = notificationsFacade.find(notiId);
                    noti.setContent("This comment has been deleted");
                    notificationsFacade.edit(noti);
                    out.print("true");
                } catch (Exception e) {
                    out.print("false");
                }
                break;
            }
        }
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
