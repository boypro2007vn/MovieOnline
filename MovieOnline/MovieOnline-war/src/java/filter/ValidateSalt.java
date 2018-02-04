/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package filter;

import com.google.common.cache.Cache;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 *
 * @author namin
 */
@WebFilter(filterName = "ValidateSalt",urlPatterns = {"/AdminLoginServlet","/deleteMovie","/deleteEpisode"})
public class ValidateSalt implements Filter{

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        // Assume its HTTP
        HttpServletRequest httpReq = (HttpServletRequest) request;
        // Get the salt sent with the request
        String salt = (String) httpReq.getParameter("csrfSalt");

        // Validate that the salt is in the cache
        Cache<String, Boolean> csrfPreventionSaltCache = (Cache<String, Boolean>)
            httpReq.getSession().getAttribute("csrfPreventionSaltCache");

        if (csrfPreventionSaltCache != null &&
                salt != null &&
                csrfPreventionSaltCache.getIfPresent(salt) != null){

            // If the salt is in the cache, we move on
            chain.doFilter(request, response);
        } else {
            request.getRequestDispatcher("404.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        
    }
    
}
