/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.NotificationsFacadeLocal;
import bean.TypeVipFacadeLocal;
import entity.Accounts;
import entity.Notifications;
import entity.TypeVip;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author chris
 */
@WebServlet(name = "AdminDeleteVipServlet", urlPatterns = {"/deleteVip"})
public class AdminDeleteVipServlet extends HttpServlet {
    @EJB
    private TypeVipFacadeLocal typeVipFacade;
    @EJB
    private NotificationsFacadeLocal notificationsFacade;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        int id = 0;
        TypeVip typevip = null;
        Accounts acc = (Accounts) request.getSession().getAttribute("user");
        try {
            id = Integer.parseInt(request.getParameter("typeVipId"));
            typevip = typeVipFacade.find(id);
            if(typevip == null || id ==0){
                out.print("false");
            }else{
                typeVipFacade.remove(typevip);
            }
            Notifications noti = new Notifications();
                if (acc != null) {
                    noti.setSenderID(acc.getAccountId());
                    noti.setName(acc.getUserName());
                    noti.setEmail(acc.getEmail());
                    noti.setRecipientID(0);
                    noti.setGroupID(acc.getRole());
                    noti.setTitle("TASK");
                    noti.setContent(typevip.getName()+" package has been deleted by <span style='color:red'>" + acc.getUserName() + "</span>");
                    noti.setType("SYSTEM-ADMIN");
                    noti.setTime(new Timestamp(System.currentTimeMillis()));
                    noti.setIsUnread(false);
                    notificationsFacade.create(noti);
                }
        } catch (Exception e) {
            out.print("false");
        }
        out.print("true");
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
