/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package filter;

import bean.AccountsFacadeLocal;
import bean.CountryFacadeLocal;
import bean.GenreFacadeLocal;
import entity.Accounts;
import entity.Country;
import entity.Genre;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObjectBuilder;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Encrypt;

/**
 *
 * @author namin
 */
@WebFilter(filterName = "Template",urlPatterns = {"/*"})
public class Template implements Filter{
    AccountsFacadeLocal accountsFacade = lookupAccountsFacadeLocal();
    GenreFacadeLocal genreFacade = lookupGenreFacadeLocal();
    CountryFacadeLocal countryFacade = lookupCountryFacadeLocal();
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        Cookie cookie = null;
        JsonArray jsonArray = null;
        boolean countryFlag =false;
        boolean genreFlag = false;
        Cookie[] cookies =null;
        if(httpRequest.getCookies()!=null){
            cookies = httpRequest.getCookies();
            for (Cookie item : cookies) {
                if(item.getName().equals("CountryCookie")){
                    countryFlag = true;
                }
                if(item.getName().equals("GenreCookie")){
                    genreFlag = true;
                }
                if(item.getName().equals("GenreCookie")){
                    genreFlag = true;
                }
            }
        }
        if(!countryFlag){
            try {
                List<Country> list = countryFacade.findAll();
                JsonArrayBuilder jsonBuilder = Json.createArrayBuilder();
            for (Country country : list) {
                JsonObjectBuilder jsonObject = Json.createObjectBuilder()
                        .add("countryOrder", country.getCountryOrder())
                        .add("countryName", country.getCountryName())
                        .add("countryId", country.getCountryId());
                        
                        
                jsonBuilder.add(jsonObject);
                }
                jsonArray = jsonBuilder.build();
                cookie = new Cookie("CountryCookie",jsonArray.toString());
                httpResponse.addCookie(cookie);
                request.setAttribute("CountryCookie", list);
            } catch (Exception e) {
                e.printStackTrace();
            }
            
        }
        if(!genreFlag){
            try {
                List<Genre> list = genreFacade.findAll();
            JsonArrayBuilder jsonBuilder = Json.createArrayBuilder();
            for (Genre genre : list) {
                JsonObjectBuilder jsonObject = Json.createObjectBuilder()
                        .add("genreOrder", genre.getGenreOrder())
                        .add("genreName", genre.getGenreName())
                        .add("genreId", genre.getGenreId());
                jsonBuilder.add(jsonObject);
                }
                jsonArray = jsonBuilder.build();
                cookie = new Cookie("GenreCookie",jsonArray.toString());
                httpResponse.addCookie(cookie);
                request.setAttribute("GenreCookie", list);
            } catch (Exception e) {
                e.printStackTrace();
            }
            
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
       
    }

    private CountryFacadeLocal lookupCountryFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (CountryFacadeLocal) c.lookup("java:global/MovieOnline/MovieOnline-ejb/CountryFacade!bean.CountryFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private GenreFacadeLocal lookupGenreFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (GenreFacadeLocal) c.lookup("java:global/MovieOnline/MovieOnline-ejb/GenreFacade!bean.GenreFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

    private AccountsFacadeLocal lookupAccountsFacadeLocal() {
        try {
            Context c = new InitialContext();
            return (AccountsFacadeLocal) c.lookup("java:global/MovieOnline/MovieOnline-ejb/AccountsFacade!bean.AccountsFacadeLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }
    
}
