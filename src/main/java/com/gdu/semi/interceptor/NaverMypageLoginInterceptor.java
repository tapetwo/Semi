package com.gdu.semi.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.gdu.semi.domain.UserDTO;

@Component
public class NaverMypageLoginInterceptor implements HandlerInterceptor {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		HttpSession session = request.getSession();
		UserDTO user = (UserDTO) session.getAttribute("loginUser");
		
		if(user == null) {
			return false;
		} else {
			if(user.getSnsType() == null) {
				return true;
			} else {
					if(user.getSnsType().equals("naver")) {
						
						response.setContentType("text/html; charset=UTF-8");
						PrintWriter out = response.getWriter();
						
						out.println("<script>");
						out.println("alert('네이버 회원은 마이페이지를 사용할 수 없습니다.');");
						out.println("location.href='" + request.getContextPath() + "';");
						out.println("</script>");
						out.close();
						
						return false;
						
					} else {
						
						return true;
						
					}
			}
		}
		
	}
	
}