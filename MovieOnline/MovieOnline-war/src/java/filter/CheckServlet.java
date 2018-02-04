/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package filter;

import entity.Accounts;
import java.io.IOException;
import java.util.Collection;
import java.util.regex.Pattern;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRegistration;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import main.Check;
import org.jboss.weld.context.RequestContext;

/**
 *
 * @author namin
 */
@WebFilter(filterName = "CheckServlet",urlPatterns = {"/*"})
public class CheckServlet implements Filter{
    public boolean checkREquest(HttpServletRequest request){
        String serverPath = request.getServletPath();
        String pathInfo = request.getPathInfo();
        String urlPattern = serverPath;
        if(pathInfo !=null){
            urlPattern = serverPath + "/*";
        }

        Collection<? extends ServletRegistration> values = request.getServletContext()
                                                .getServletRegistrations().values();
        for (ServletRegistration sr : values) {
            Collection<String> mappings = sr.getMappings();
            if (mappings.contains(urlPattern) || urlPattern.contains("/public")|| urlPattern.contains("/moviesSource") || urlPattern.contains("/adminnoti")) {
                Accounts acc = (Accounts) request.getSession().getAttribute("user");
                if((Check.checkHDUrl(urlPattern) && acc==null) || (Check.checkHDUrl(urlPattern) && acc.getRole().getName().equalsIgnoreCase("ROLE_MEMBER"))){
                    return false;
                }
                return true;
            }
        }
        return false;

    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletResponse myRes = (HttpServletResponse) response;
        if(this.checkREquest((HttpServletRequest) request)){
            HttpServletRequest myReq = (HttpServletRequest) request;
            String reqURI = myReq.getRequestURI();
            try{
                request.setAttribute("requestURI",reqURI);
                chain.doFilter(request, response);
            }catch(Exception e){
                e.printStackTrace();
            }
        }else{
            request.getRequestDispatcher("404.jsp").forward(request, response);
        }

    }

    @Override
    public void destroy() {
        
    }
    
}
