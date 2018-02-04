/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import bean.AccountVipHistoryFacadeLocal;
import bean.AccountsFacadeLocal;
import bean.NotificationsFacadeLocal;
import bean.RoleFacadeLocal;
import bean.TypeVipFacadeLocal;
import entity.AccountVipHistory;
import entity.Accounts;
import entity.Notifications;
import entity.Role;
import entity.TypeVip;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "CardPaymentServlet", urlPatterns = {"/CardPayment"})
public class CardPaymentServlet extends HttpServlet {

    @EJB
    private NotificationsFacadeLocal notificationsFacade;

    @EJB
    private RoleFacadeLocal roleFacade;
    @EJB
    private AccountsFacadeLocal accountsFacade;
    @EJB
    private TypeVipFacadeLocal typeVipFacade;
    @EJB
    private AccountVipHistoryFacadeLocal accountVipHistoryFacade;

    public static Date addDays(Date date, int days) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.DATE, days); //minus number would decrement the days
        return cal.getTime();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        TypeVip tv = new TypeVip();
        double price = 0;
        Date date = new Date();
        java.sql.Date sqlDate = new java.sql.Date(date.getTime());
        Accounts accCheck = (Accounts) request.getSession().getAttribute("user");
        if (accCheck.getBanned()) {
            request.getRequestDispatcher("404.jsp").forward(request, response);
        }
        try {
            price = Double.parseDouble(request.getParameter("pricehidden"));
        } catch (Exception e) {
            request.setAttribute("statusError", "displayStatus");
            request.getRequestDispatcher("u_payment_status.jsp").forward(request, response);
        }
        try {
            Accounts acc = accountsFacade.find(accCheck.getAccountId());
            TypeVip typeVip = typeVipFacade.searchByPrice(price);
            System.out.println(acc.getDayVipEnd());
            int duration = typeVipFacade.searchByPrice(price).getDuration();
            String dayvipend = "";
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            //tao dayvipend khi dayvipend = null, lay ngay mua + duration
            if ((sdf.parse(accCheck.getDayVipEnd())).getTime() - (new Date().getTime()) <0) {
                Date dayvipstart = new Date();                
                dayvipend = sdf.format(dayvipstart);
                Calendar c = Calendar.getInstance();
                c.setTime(sdf.parse(dayvipend));
                c.add(Calendar.DATE, duration);  // number of days to add
                dayvipend = sdf.format(c.getTime());  // dt is now the new date                
            } //neu co dayvipend thi lay dayvipend + duration
            else {
                String dayvipstart = acc.getDayVipEnd();                
                Calendar c = Calendar.getInstance();
                c.setTime(sdf.parse(dayvipstart));
                c.add(Calendar.DATE, duration);  // number of days to add
                dayvipend = sdf.format(c.getTime());  // dt is now the new date                
            }
            int roleId = acc.getRole().getRoleId();
            if (roleId == 4) {
                Role roleEdit = roleFacade.find(3);
                acc.setRole(roleEdit);
                acc.setIsVip(true);
            }
            acc.setDayVipEnd(dayvipend);
            accountsFacade.edit(acc);
            AccountVipHistory avh = new AccountVipHistory();
            avh.setTypeVipId(typeVipFacade.searchByPrice(price));
            avh.setDateRegister(sqlDate.toString());
            avh.setAccountId((Accounts) request.getSession().getAttribute("user"));
            accountVipHistoryFacade.create(avh);
            request.setAttribute("duration", typeVipFacade.searchByPrice(price).getDuration());
            request.setAttribute("statusSuccess", "displayStatus");
            request.getSession().setAttribute("user", acc);
            Notifications noti = new Notifications();
            if (acc != null) {
                noti.setSenderID(acc.getAccountId());
                noti.setName(acc.getUserName());
                noti.setEmail(acc.getEmail());
                noti.setRecipientID(0);
                noti.setGroupID(acc.getRole());
                noti.setTitle("PAYMENT");
                noti.setContent("<span style='color:red'>" + acc.getUserName() + "</span> has been purchase a " + typeVip.getName() + " pack");
                noti.setType("SYSTEM-USER");
                noti.setTime(new Timestamp(System.currentTimeMillis()));
                noti.setIsUnread(false);
                notificationsFacade.create(noti);
            }
            request.getRequestDispatcher("u_payment_status.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("statusError", "displayStatus");
            e.printStackTrace();
            request.getRequestDispatcher("u_payment_status.jsp").forward(request, response);
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
