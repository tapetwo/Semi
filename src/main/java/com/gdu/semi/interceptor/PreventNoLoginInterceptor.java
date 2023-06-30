package com.gdu.semi.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class PreventNoLoginInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		
		if(request.getSession().getAttribute("loginUser") == null) {
			
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			
			out.println("<script>");
			out.println("alert('로그인이 필요한 기능입니다. 로그인 페이지로 이동합니다.');");
			out.println("location.href='" + request.getContextPath() + "/user/login/form';");
			out.println("</script>");
			out.close();
			
			return false;  
			
		} else {
			
			return true;  
			
		}
		
	}
	
}