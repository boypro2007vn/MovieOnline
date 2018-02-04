/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import bean.CommentsFacadeLocal;
import bean.NotificationsFacadeLocal;
import bean.TypeVipFacadeLocal;
import entity.Accounts;
import entity.Notifications;
import java.io.IOException;
import java.io.PrintWriter;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Check;
import entity.TypeVip;
import java.sql.Timestamp;

/**
 *
 * @author chris
 */
@WebServlet(name = "AdminInsertVip", urlPatterns = {"/AdminInsertVip"})
public class AdminInsertVip extends HttpServlet {

    @EJB
    private NotificationsFacadeLocal notificationsFacade;

    @EJB
    private TypeVipFacadeLocal typeVipFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String error = "false";
        String viptype = Check.removeSpace(request.getParameter("viptype")).trim();
        if (typeVipFacade.searchByName(viptype)) {
            error = "duplicate";
            out.print("duplicate");
        }
        if (!error.equals("duplicate")) {
            int duration = 0;
            float price = 0;
            Accounts acc = (Accounts) request.getSession().getAttribute("user");
            String priceStr = "";
            try {
                duration = Integer.parseInt(request.getParameter("duration"));
                priceStr = Check.removeComma(request.getParameter("price"));
                price = Float.parseFloat(priceStr);
            } catch (Exception e) {
                error = "true";
            }
            if (viptype.isEmpty() || viptype == null) {
                error = "true";
            }
            if (error.equals("true")) {
                out.print("true");
            } else {
                try {
                    TypeVip typevip = new TypeVip();
                    typevip.setName(viptype);
                    typevip.setDuration(duration);
                    typevip.setPrice(price);
                    typeVipFacade.create(typevip);
                    Notifications noti = new Notifications();
                    if (acc != null) {
                        noti.setSenderID(acc.getAccountId());
                        noti.setName(acc.getUserName());
                        noti.setEmail(acc.getEmail());
                        noti.setRecipientID(0);
                        noti.setGroupID(acc.getRole());
                        noti.setTitle("TASK");
                        noti.setContent("<span style='color:red'>" + acc.getUserName() + "</span> has been created a new VIP package named: " + viptype);
                        noti.setType("SYSTEM-ADMIN");
                        noti.setTime(new Timestamp(System.currentTimeMillis()));
                        noti.setIsUnread(false);
                        notificationsFacade.create(noti);
                    }
                    out.print("false");
                } catch (Exception e) {
                    out.print("true");
                }

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
