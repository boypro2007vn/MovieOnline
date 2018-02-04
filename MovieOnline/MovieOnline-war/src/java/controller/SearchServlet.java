/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import bean.MoviesFacadeLocal;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.MovieDB;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "SearchServlet", urlPatterns = {"/Search"})
public class SearchServlet extends HttpServlet {

    @EJB
    private MoviesFacadeLocal moviesFacade;

    private String changeUnicode(String text){
        byte[] bytes = text.getBytes(StandardCharsets.ISO_8859_1);
        return new String(bytes, StandardCharsets.UTF_8);
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        String titleSearch = "Search Result";
        String searchType = request.getParameter("searchType");              
        List<MovieDB> list;
        switch (searchType) {
            case "header":
                String titleheader = changeUnicode(request.getParameter("titleHeader"));
                list = moviesFacade.searchHeader(titleheader);
                request.setAttribute("list", list);
                request.setAttribute("titleSearch", titleSearch);
                request.getRequestDispatcher("u_search_movie.jsp").forward(request, response);
                break;
            case "filter":     
                int id = -1;
                String title = "";                
                String actor = "";
                String director = "";
                int type = -1;
                int uploadDay = -1;
                int releaseDay = -1;
                String countryName = "";
                String genreName = "";
                int views = -1;
                int order =-1;
                try {
                    order = Integer.parseInt(request.getParameter("order"));
                } catch (Exception e) {
                    order=-1;
                }
                if(order==0){
                    uploadDay = 1;
                }else{
                    views = 1;
                }
                
                try {
                    type = Integer.parseInt(request.getParameter("type"));
                } catch (Exception e) {
                    type = -1;
                }            
                try {
                    releaseDay = Integer.parseInt(request.getParameter("releaseDay"));
                } catch (Exception e) {
                    releaseDay = -1;
                }         
                if (request.getParameter("title") != null) {
                    title = changeUnicode(request.getParameter("title"));
                }else{
                    title = "";
                }
                if (request.getParameter("actor") != null) {
                    actor = changeUnicode(request.getParameter("actor"));
                }else{
                    actor = "";
                }
                if (request.getParameter("director") != null) {
                    director = changeUnicode(request.getParameter("director"));
                }else{
                    director = "";
                }
                if (request.getParameter("countryName") != null) {
                    countryName = request.getParameter("countryName");
                }else{
                    countryName = "";
                }
                if (request.getParameter("genreName") != null) {
                    genreName = request.getParameter("genreName");
                }else{
                    genreName = "";
                }           
                list = moviesFacade.searchMovie(id, title, actor, director, type, uploadDay,releaseDay, countryName, genreName, views);
                request.setAttribute("list", list);
                if(request.getParameter("searchname") != null){
                    if(request.getParameter("searchname").equalsIgnoreCase("movie")){
                        titleSearch = "Movie";
                    }
                        
                    if(request.getParameter("searchname").equals("tv")){
                        titleSearch = "Television Series";
                    }
                }
                
                request.setAttribute("titleSearch", titleSearch);
                request.getRequestDispatcher("u_search_movie.jsp").forward(request, response);                
                break;
            default:
                request.getRequestDispatcher("home").forward(request, response);
                break;
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
