/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.AccountsFacadeLocal;
import bean.MoviesFacadeLocal;
import bean.RatingFacadeLocal;
import entity.Accounts;
import entity.Movies;
import entity.Rating;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Common;
import org.json.JSONObject;

/**
 *
 * @author namin
 */
@WebServlet(name = "ratingServlet", urlPatterns = {"/ratingServlet"})
public class ratingServlet extends HttpServlet {
    @EJB
    private AccountsFacadeLocal accountsFacade;
    @EJB
    private MoviesFacadeLocal moviesFacade;
    @EJB
    private RatingFacadeLocal ratingFacade;


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        int movieId= 0;
        int userId=0;
        int star = 0;
        String result = "";
        String rateCount="";
        String ratePoint="";
        LinkedHashMap<String,Integer> ratingList =Common.getRatingList();
        try {
            movieId = Integer.parseInt(request.getParameter("movieId"));
            userId = Integer.parseInt(request.getParameter("userId"));
            star = Integer.parseInt(request.getParameter("star"));
            Accounts acc = accountsFacade.find(userId);
            Movies movie = moviesFacade.find(movieId);
            if(ratingFacade.checkAccountRating(acc, movie)){
                result ="exist";
                rateCount="\"\"";
                ratePoint="\"\"";
            }else{
                Rating rate = new Rating();
                rate.setAccountId(acc);
                rate.setMovieId(movie);
                rate.setStar(star);
                ratingFacade.create(rate);
                result = "true";
                rateCount = String.valueOf(ratingFacade.getCountRatingByMovie(movie));
                ratePoint = ratingFacade.getRatePointByMovie(movie);
                List<Rating> ratingL = ratingFacade.getRatingByMovie(moviesFacade.find(movie.getMovieId()));
                if (ratingL.size() > 0) {
                    List<Map.Entry<String, Integer>> randAccess = new ArrayList<Map.Entry<String, Integer>>(ratingList.entrySet());
                    for (Rating rt : ratingL) {
                        String key = randAccess.get(rt.getStar() - 1).getKey();
                        ratingList.put(key, ratingList.get(key) + 1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            result = "false";
            rateCount="\"\"";
            ratePoint="\"\"";
        }
        
        StringBuilder resultJson = new StringBuilder()
                .append("{\"result\":").append("\""+result+"\"")
                .append(",\"rateCount\":").append(rateCount)
                .append(",\"ratePoint\":").append(ratePoint)
                .append(",\"rateList\":").append(new JSONObject(ratingList))
                .append("}");
        out.print(resultJson.toString());
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
