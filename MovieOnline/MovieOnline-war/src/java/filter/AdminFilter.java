/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package filter;

import bean.AccountsFacadeLocal;
import entity.Accounts;
import entity.Role;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
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
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 *
 * @author namin
 */
@WebFilter(filterName = "AdminFilter",servletNames = {
    "AdminHomeServlet","AdminMoviesList","AdminUploadMovieServlet","AdminUploadInfoMovieServlet","AdminDeleteMovieServlet","AdminDeleteEpisodeServlet","AdminReUploadServlet",
    "AdminUploadResourceMovieServlet","AdminUploadSubtitle","AdminStatisticServlet","AdsServlet"
})
public class AdminFilter implements Filter{
    AccountsFacadeLocal accountsFacade = lookupAccountsFacadeLocal();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpSession session=httpReq.getSession();
        Accounts acc = (Accounts)session.getAttribute("user");
        boolean flag = false;
        if(acc !=null){
           Role role = accountsFacade.getRole(acc);
           if(role.getName().equalsIgnoreCase("ROLE_ADMIN") || role.getName().equalsIgnoreCase("ROLE_UPLOADER")){
              flag = true;
           }        
        }
        if(flag){
            chain.doFilter(request, response);
        }else{
            request.getRequestDispatcher("admin_page/admin_login.jsp").forward(request, response);
        }
        
    }

    @Override
    public void destroy() {
        
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
