package com.gdu.semi.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.gdu.semi.domain.SleepUserDTO;
import com.gdu.semi.domain.UserDTO;

public interface UserService {
	
	public Map<String, Object> isReduceId(String id);
	public Map<String, Object> isReduceEmail(String email);
	public Map<String, Object> isReduceFindEmail(String email);
	public Map<String, Object> sendAuthCode(String email);
	public Map<String, Object> findId(String email);
	public Map<String, Object> findpw(String email, String id);
	public Map<String, Object> sendPw(String email, String id);
	public void join(HttpServletRequest request, HttpServletResponse response);
	public void retire(HttpServletRequest request, HttpServletResponse response);
	public void login(HttpServletRequest request, HttpServletResponse response);
	public void keepLogin(HttpServletRequest request, HttpServletResponse response);
	public UserDTO getUserBySessionId(Map<String, Object> map);
	public Map<String, Object> confirmPassword(HttpServletRequest request);
	public void logout(HttpServletRequest request, HttpServletResponse response);
	public void modifyPassword(HttpServletRequest request, HttpServletResponse response);
	public void modify(HttpServletRequest request, HttpServletResponse response);
	public void sleepUserHandle();  // SleepUserSchedular에서 호출
	public SleepUserDTO getSleepUserById(String id);
	public void restoreUSer(HttpServletRequest request, HttpServletResponse response);
	public String getNaverLoginApiURL(HttpServletRequest request);  
	public String getNaverLoginToken(HttpServletRequest request);   
	public UserDTO getNaverLoginProfile(String access_token);       
	public UserDTO getNaverUserById(String id);
	public void naverLogin(HttpServletRequest request, UserDTO naverUser);
	public void naverJoin(HttpServletRequest request, HttpServletResponse response);
}
