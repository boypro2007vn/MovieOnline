/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.AccountVipHistoryFacadeLocal;
import bean.AccountsFacadeLocal;
import bean.CountViewMovieBeanLocal;
import bean.MoviesFacadeLocal;
import bean.NotificationsFacadeLocal;
import com.google.gson.Gson;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.MovieView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author namin
 */
@WebServlet(name = "AdminHomeServlet", urlPatterns = {"/admin"})
public class AdminHomeServlet extends HttpServlet {
    @EJB
    private MoviesFacadeLocal moviesFacade;
    @EJB
    private AccountsFacadeLocal accountsFacade;
    @EJB
    private NotificationsFacadeLocal notificationsFacade;
    @EJB
    private CountViewMovieBeanLocal countViewMovieBean;
    @EJB
    private AccountVipHistoryFacadeLocal accountVipHistoryFacade;
    
    
    private Date getDay(String date){
        String[] dayArr = date.split("-");
        int year = Integer.parseInt(dayArr[0]);
        int month = Integer.parseInt(dayArr[1]);
        int day = Integer.parseInt(dayArr[2]);
        return new Date(year,month,day);
    }
    private int getMonthsDifference(String from, String to) {
        Date df = getDay(from);
        Date dt = getDay(to);
        int m1 = df.getYear() * 12 + df.getMonth();
        int m2 = dt.getYear() * 12 + dt.getMonth();
        return m2 - m1 + 1;
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, JSONException {
        String currentDay = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        List lyear = accountVipHistoryFacade.getUserStatistic(0);
        float totalUserPay = accountVipHistoryFacade.getTotalUserPayment();
        int countUserPay = accountVipHistoryFacade.getCountUserPayment(0);
        request.setAttribute("totalPayment", totalUserPay);
        request.setAttribute("listStatistic", new Gson().toJson(lyear));
        request.setAttribute("countUserPay", countUserPay);
        
        
        request.setAttribute("viewcount", moviesFacade.countView());
        request.setAttribute("viewcountday", countViewMovieBean.getCountViewByDay());
        Hashtable<Integer,Integer> movieViews = countViewMovieBean.getListViewByDay();
        List<MovieView> listMovieView = new ArrayList<>();
        Set<Integer> keys = movieViews.keySet();
        MovieView movie;
        for(Integer key: keys){
            movie = new MovieView(moviesFacade.find(key), movieViews.get(key));
            listMovieView.add(movie);
        }
        request.setAttribute("listviewcountday", listMovieView);
        
        request.setAttribute("countUser",   accountsFacade.count());//so nguoi dang ky
        request.setAttribute("countUserday",   accountsFacade.countAccountByDay(currentDay));
        
        request.setAttribute("countMovie",   moviesFacade.count());
        request.setAttribute("countMovieday",   moviesFacade.countMovieByDay(currentDay));
        
        request.setAttribute("countPayment",   accountVipHistoryFacade.count());
        request.setAttribute("countPaymentday",   accountVipHistoryFacade.countAccountVipHistoryByDay(currentDay));
        
        request.getRequestDispatcher("/admin_page/admin_template.jsp").forward(request, response);
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
            Logger.getLogger(AdminHomeServlet.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(AdminHomeServlet.class.getName()).log(Level.SEVERE, null, ex);
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
