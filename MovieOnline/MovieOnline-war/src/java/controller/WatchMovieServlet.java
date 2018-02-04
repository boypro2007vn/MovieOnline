/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import bean.CommentsFacadeLocal;
import bean.EpisodeFacadeLocal;
import bean.MoviesFacadeLocal;
import bean.RatingFacadeLocal;
import entity.Comments;
import entity.Episode;
import entity.Genre;
import entity.Movies;
import entity.Rating;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import javax.ejb.EJB;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Common;
import model.MovieDB;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author namin
 */
@WebServlet(name = "WatchMovieServlet", urlPatterns = {"/watchmovie"})
public class WatchMovieServlet extends HttpServlet {
    @EJB
    private CommentsFacadeLocal commentsFacade;
    @EJB
    private RatingFacadeLocal ratingFacade;
    @EJB
    private EpisodeFacadeLocal episodeFacade;
    @EJB
    private MoviesFacadeLocal moviesFacade;
    
    private void setAds(HttpServletRequest request,HttpServletResponse response,ServletContext context) throws JSONException, IOException{
        Cookie[] cookies = null;
        boolean flag = false;
        if(request.getCookies()!=null){
            cookies = request.getCookies();
            for(Cookie c:cookies){
                if(c.getName().equalsIgnoreCase("ads-video")){
    //                c.setMaxAge(0);
    //                response.addCookie(c);
                    flag = true;
                    break;
                }
            }
        }
        if(!flag){
            File file = new File(context.getRealPath("/moviesSource/ads/adslist.txt"));
            if(file.exists()){
                try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                    String sCurrentLine;
                    if ((sCurrentLine = br.readLine()) != null) {
                        JSONArray arrAll= new JSONArray(sCurrentLine);
                        Cookie myCookie = new Cookie("ads-video", arrAll.toString());
                        myCookie.setMaxAge(5*60);
                        response.addCookie(myCookie);
                    }
                    
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            
        }
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id =0;
        boolean error =false;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            error =true;
        }
        if(!error){
            try {
                MovieDB movie = moviesFacade.getDetailMovies(id);
                if(movie==null || !movie.isStatus()){
                        request.setAttribute("errorTitle", "MOVIE NOT FOUND");
                        request.setAttribute("errorBody", "The movie may have been removed or not exist.");
                        request.getRequestDispatcher("404.jsp").forward(request, response);
                }else{ 
                    if(movie.getNumberEpisode()==0){
                        request.getRequestDispatcher("404.jsp").forward(request, response);
                    }else{
                        request.setAttribute("detailMovie", movie);
                        Map<String, LinkedList<List<Episode>>> mapEpisode = new LinkedHashMap<>();
                        List<Episode> list = episodeFacade.getEpisodeByMovieIDStorePro(id);
                        if(movie.getNumberEpisode() >1 || movie.isType()){
                            for (Episode epi : list) {
                                if (!epi.getRes360().equals("") || !epi.getRes480().equals("") || !epi.getRes720().equals("") || !epi.getRes1080().equals("")) {
                                    if (mapEpisode.containsKey(epi.getLanguage())) {
                                        LinkedList<List<Episode>> curLinks = mapEpisode.get(epi.getLanguage());
                                        int size = curLinks.size();
                                        for (int i = 0; i < size; i++) {
                                            boolean flag = false;
                                            for (Episode e : curLinks.get(i)) {
                                                if (e.getEpisodeName() == epi.getEpisodeName()) {
                                                    flag = true;
                                                }
                                            }
                                            if (flag) {
                                                List<Episode> listChild = new ArrayList<>();
                                                listChild.add(epi);
                                                curLinks.add(listChild);
                                                mapEpisode.put(epi.getLanguage(), curLinks);
                                            } else {
                                                curLinks.get(i).add(epi);
                                                mapEpisode.put(epi.getLanguage(), curLinks);
                                                break;
                                            }
                                        }
                                    } else {
                                        List<Episode> listChild = new ArrayList<>();
                                        listChild.add(epi);
                                        LinkedList<List<Episode>> linkedChild = new LinkedList<>();
                                        linkedChild.add(listChild);
                                        mapEpisode.put(epi.getLanguage(), linkedChild);
                                    }
                                }
                            }
                            
                        }
                        LinkedHashMap<String,Integer> ratingList = Common.getRatingList();
                        List<Rating> ratingL = ratingFacade.getRatingByMovie(moviesFacade.find(movie.getMovieId()));
                        if(ratingL.size()>0){
                            List<Map.Entry<String,Integer>> randAccess = new ArrayList<Map.Entry<String,Integer>>(ratingList.entrySet());
                            for(Rating rate : ratingL){
                                String key = randAccess.get(rate.getStar()-1).getKey();
                                ratingList.put(key, ratingList.get(key)+1);
                            }
                        }
                        setAds(request,response,getServletContext());
                        Movies movieEntity = moviesFacade.find(id);
                        List<Comments> commentList = commentsFacade.findCommentByMovieId(movieEntity);
                        
                        int randomGenre = new Random().nextInt(movieEntity.getGenreCollection().size());
                        String[] listActor = movieEntity.getActors().split(",");
                        int randomActor = new Random().nextInt(listActor.length);
                        List<MovieDB> resMovie = moviesFacade.getRelatedMovies(movieEntity.getMovieId(), movieEntity.getRealTitle(), ((List<Genre>)movieEntity.getGenreCollection()).get(randomGenre).getGenreName(), listActor[randomActor], movie.getCountryName());
                        
                        
                        request.setAttribute("firstEpisode", list.get(0));
                        request.setAttribute("ratingList", ratingList);
                        request.setAttribute("commentList", commentList);
                        request.setAttribute("episode", mapEpisode);
                        request.setAttribute("recomenderList", resMovie);
                        request.getRequestDispatcher("u_watch_movie.jsp").forward(request, response);
                    }
                    
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getRequestDispatcher("404.jsp").forward(request, response);
            }
        }else{
            request.getRequestDispatcher("404.jsp").forward(request, response);
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
