/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import bean.AccountVipHistoryFacadeLocal;
import bean.AccountsFacadeLocal;
import entity.AccountVipHistory;
import entity.Accounts;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.ConcurrentModificationException;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.PaymentHistory;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "UserHistoryServlet", urlPatterns = {"/UserHistory"})
public class UserHistoryServlet extends HttpServlet {

    @EJB
    private AccountsFacadeLocal accountsFacade;

    @EJB
    private AccountVipHistoryFacadeLocal accountVipHistoryFacade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        List<PaymentHistory> listHistory = new ArrayList();
        List<PaymentHistory> newlistHistory = new ArrayList();
        PaymentHistory avh;
        Accounts accCheck = (Accounts) request.getSession().getAttribute("user");
        if (accCheck == null) {
            request.getRequestDispatcher("home").forward(request, response);
        } else {
            listHistory = accountVipHistoryFacade.getHistoryPaymentDetail();
            System.out.println(accCheck.getAccountId());
            for (PaymentHistory paymentHistory : listHistory) {
                try {
                    if (accCheck.getAccountId() == paymentHistory.getAccountId()) {
                        String dateWeb = main.Check.convertDay2(paymentHistory.getDateRegister());
                        avh = new PaymentHistory();
                        avh.setHistoryId(paymentHistory.getHistoryId());
                        avh.setDuration(paymentHistory.getDuration());
                        avh.setPrice(paymentHistory.getPrice());
                        avh.setDateRegister(dateWeb);
                        newlistHistory.add(avh);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            request.setAttribute("accDetail", accountsFacade.find(accCheck.getAccountId()));
            String dayvipendStr = accCheck.getDayVipEnd();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            try {
                Date d = sdf.parse(dayvipendStr);
                long dayvipend = d.getTime();
                long curDate = new Date().getTime();
                long finalDay = 0;
                if ((dayvipend - curDate) < 0) {
                    request.setAttribute("vipdays", finalDay);
                } else {
                    long finalDate = dayvipend - curDate;
                    finalDay = TimeUnit.DAYS.convert(finalDate, TimeUnit.MILLISECONDS);
                    request.setAttribute("vipdays", finalDay);
                }
                System.out.println(finalDay);
            } catch (Exception e) {
                e.printStackTrace();
            }
            request.setAttribute("list", newlistHistory);
            request.getRequestDispatcher("u_history.jsp").forward(request, response);
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
