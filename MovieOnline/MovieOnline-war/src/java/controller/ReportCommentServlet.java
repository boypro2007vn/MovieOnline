/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import bean.AccountsFacadeLocal;
import bean.CommentsFacadeLocal;
import bean.NotificationsFacadeLocal;
import bean.RoleFacadeLocal;
import entity.Accounts;
import entity.Comments;
import entity.Notifications;
import entity.Role;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Message;
import main.NotiAdminClient;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "ReportCommentServlet", urlPatterns = {"/ReportComment"})
public class ReportCommentServlet extends HttpServlet {
    @EJB
    private NotificationsFacadeLocal notificationsFacade;
    @EJB
    private CommentsFacadeLocal commentsFacade;
    @EJB
    private RoleFacadeLocal roleFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String typeRequest = request.getParameter("type");
        switch (typeRequest) {
            case "createReport": {
                String type = request.getParameter("typeError");
                String typeError = "";
                switch (type) {
                    case "1": {
                        typeError = "It's harassing me or someone I know";
                        break;
                    }
                    case "2": {
                        typeError = "It's threatening, violent or suicidal";
                        break;
                    }
                    case "3": {
                        typeError = "It's hate speech";
                        break;
                    }
                    case "4": {
                        typeError = "It's offense against the policy of our country";
                        break;
                    }
                    case "5": {
                        typeError = "Other";
                        break;
                    }
                }
                String content = request.getParameter("content");
                if (content == null) {
                    content = "empty";
                }
                int commentUserId = Integer.parseInt(request.getParameter("commentUserId"));
                
                int commentId = Integer.parseInt(request.getParameter("commentId"));
                Comments comment = commentsFacade.find(commentId);                
                Accounts acc = (Accounts) request.getSession().getAttribute("user");
                String name = "Guest";
                String email = "";
                Role role = roleFacade.find(4);
                int senderID = Integer.parseInt(request.getRemoteAddr().replaceAll(":", "").replaceAll("\\.", ""));
                Timestamp timeRequest = new Timestamp(System.currentTimeMillis());
                if (acc != null) {
                    senderID = acc.getAccountId();
                    name = acc.getUserName();
                    email = acc.getEmail();
                    role = acc.getRole();
                }
                String title = request.getParameter("title");
                if (notificationsFacade.checkSender(senderID, timeRequest,title)) {
                    out.print("spam");
                } else {
                    try {
                        Notifications noti = new Notifications();
                        noti.setSenderID(senderID);
                        noti.setName(name);
                        noti.setEmail(email);
                        noti.setRecipientID(commentUserId);
                        noti.setGroupID(role);
                        noti.setTitle("REPORT COMMENT");
                        noti.setContent("<span style='color:red'>" + name + "</span> has reported " + comment.getAccountId().getUserName() + 
                                "'s comment with ID: <a>"+comment.getCommentId()+"</a><p><strong>Type: </strong>" + typeError + "</br><strong>Comment: </strong>"
                                + comment.getContent() + "</br><strong>Report Content: </strong>" + content + "</p>");
                        noti.setType("SYSTEM-ADMIN");
                        noti.setTime(timeRequest);
                        noti.setIsUnread(false);
                        notificationsFacade.create(noti);
                        out.print("false");
                    } catch (Exception e) {
                        out.print("true");
                    }                    
                }
                break;
            }
            case "reportList": {
                String title = request.getParameter("title");
                request.setAttribute("list", notificationsFacade.getCommentReport(title));
                
                request.getRequestDispatcher("admin_page/admin_report_comment.jsp").forward(request, response);
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
