/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.AccountVipHistoryFacadeLocal;
import bean.MoviesFacadeLocal;
import entity.AccountVipHistory;
import entity.Genre;
import entity.Movies;
import entity.Rating;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Check;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author namin
 */
@WebServlet(name="reportServlet", urlPatterns={"/reportServlet"})
public class reportServlet extends HttpServlet {
    @EJB
    private AccountVipHistoryFacadeLocal accountVipHistoryFacade;
    @EJB
    private MoviesFacadeLocal moviesFacade;
   
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException, ParseException, JSONException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonObj;
        JSONArray jsonArray;
        String type = request.getParameter("sub");
        if(type.equalsIgnoreCase("movie")){
            try {
                String range[] = request.getParameter("day").split("-");
                String sday = Check.convertDay(range[0].trim());
                String eday = Check.convertDay(range[1].trim());
                jsonArray = new JSONArray();
                List<Movies> list = moviesFacade.getMovieByDayRange(sday, eday);
                for (Movies movies : list) {
                    jsonObj = new JSONObject();
                    jsonObj.put("id", movies.getMovieId());
                    jsonObj.put("name", movies.getRealTitle());
                    jsonObj.put("country", movies.getCountryId().getCountryName());
                    String genreString ="";
                    for(Genre genre : movies.getGenreCollection()){
                        genreString+= genre.getGenreName()+", ";
                    }
                    int countRate = movies.getRatingCollection().size();
                    int advrate = 0;
                    if(countRate!=0){
                        int rate =0;
                        for(Rating rates : movies.getRatingCollection()){
                            rate+= rates.getStar();
                        }
                        advrate = rate/countRate;
                    }
                    
                    jsonObj.put("genre", genreString);
                    jsonObj.put("actor", movies.getActors());
                    jsonObj.put("director", movies.getDirector());
                    jsonObj.put("releaseDay", Check.convertDay2(movies.getReleaseDay()));
                    jsonObj.put("uploadDay", Check.convertDay2(movies.getUploadDay()));
                    jsonObj.put("type", movies.getType()?"TV Series":"Movie");
                    jsonObj.put("duration", movies.getDuration());
                    jsonObj.put("views", movies.getViews());
                    jsonObj.put("rate", advrate);
                    jsonObj.put("quantity", movies.getQuantity());
                    jsonObj.put("totalEpisode", movies.getEpisodeCollection().size());
                    jsonObj.put("status", movies.getStatus()?"Enable":"Disable");
                    jsonArray.put(jsonObj);
                }
                out.print(jsonArray);
            } catch (Exception e) {
                e.printStackTrace();
                out.print("false");
            }
        }else{
            if(type.equalsIgnoreCase("payment")){
                try {
                    String range[] = request.getParameter("day").split("-");
                    String sday = Check.convertDay(range[0].trim());
                    String eday = Check.convertDay(range[1].trim());
                    jsonArray = new JSONArray();
                    List<AccountVipHistory> list = accountVipHistoryFacade.getPaymentByDayRange(sday, eday);
                    for (AccountVipHistory accountVipHistory : list) {
                        jsonObj = new JSONObject();
                        jsonObj.put("id", accountVipHistory.getHistoryId());
                        jsonObj.put("name",accountVipHistory.getAccountId().getUserName());
                        jsonObj.put("email",accountVipHistory.getAccountId().getEmail());
                        jsonObj.put("typevip",accountVipHistory.getTypeVipId().getName());
                        jsonObj.put("price", accountVipHistory.getTypeVipId().getPrice());
                        jsonObj.put("date",main.Check.convertDay2(accountVipHistory.getDateRegister()));
                        jsonArray.put(jsonObj);
                    }
                    out.print(jsonArray);
                } catch (Exception e) {
                    e.printStackTrace();
                    out.print("false");
                }
            }
            else{
                out.print("false");
            }
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(reportServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (JSONException ex) {
            Logger.getLogger(reportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(reportServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (JSONException ex) {
            Logger.getLogger(reportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
