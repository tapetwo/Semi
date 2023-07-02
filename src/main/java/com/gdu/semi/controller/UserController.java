package com.gdu.semi.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gdu.semi.domain.UserDTO;
import com.gdu.semi.service.UserService;

@Controller
public class UserController {

	@Autowired
	private UserService userService;
	
	@GetMapping("/")
	public String index() {
		return "index";
	}
	
	@GetMapping("/user/agree")
	public String agree() {
		return "user/agree";
	}
	
	@GetMapping("/user/join/write")
	public String joinWrite(@RequestParam(required=false) String location
			              , @RequestParam(required = false) String promotion
			              , Model model) {
		model.addAttribute("location", location);
		model.addAttribute("promotion", promotion);
		return "user/join";
	}
	
	@ResponseBody
	@GetMapping(value="/user/checkReduceId", produces=MediaType.APPLICATION_JSON_VALUE)
	public Map<String, Object> checkReduceId(String id){
		return userService.isReduceId(id);
	}
	
	@ResponseBody
	@GetMapping(value="/user/checkReduceEmail", produces=MediaType.APPLICATION_JSON_VALUE)
	public Map<String, Object> checkReduceEmail(String email){
		return userService.isReduceEmail(email);
	}
	
	@ResponseBody
	@GetMapping(value="/user/sendAuthCode", produces=MediaType.APPLICATION_JSON_VALUE)
	public Map<String, Object> sendAuthCode(String email){
		return userService.sendAuthCode(email);
	}
	
	@PostMapping("/user/join")
	public void join(HttpServletRequest request, HttpServletResponse response) {
		userService.join(request, response);
	}
	
	@PostMapping("/user/retire")
	public void retire(HttpServletRequest request, HttpServletResponse response) {
		userService.retire(request, response);
	}
	
	@GetMapping("/user/login/form")
	public String loginForm(HttpServletRequest request, Model model) {
		model.addAttribute("url", request.getHeader("referer"));
		model.addAttribute("apiURL", userService.getNaverLoginApiURL(request));
		return "user/login";
	}
	
	@PostMapping("/user/login")
	public void login(HttpServletRequest request, HttpServletResponse response) {
		userService.login(request, response);
	}
	
	@GetMapping("/user/logout")
	public String logout(HttpServletRequest request, HttpServletResponse response) {
		userService.logout(request, response);
		return "redirect:/";
	}
	
	@GetMapping("/user/check/form")
	public String requiredLogin_checkForm() {
		return "user/check";
	}
	
	@ResponseBody
	@PostMapping(value="user/check/pw", produces = "application/json")
	public Map<String, Object> requiredLogin_checkPw(HttpServletRequest request) {
		return userService.confirmPassword(request);
	}
	
	@GetMapping("/user/mypage")
	public String requiredLogin_mypage() {
		return "user/mypage";
	}
	
	@PostMapping("/user/modify/pw")
	public void requiredLogin_modifyPw(HttpServletRequest request, HttpServletResponse response) {
		userService.modifyPassword(request, response);
	}
	
	@PostMapping("/user/modify/info")
	public void modifyInfo(HttpServletRequest request, HttpServletResponse response) {
		userService.modify(request, response);
	}
	
	@GetMapping("/user/sleep/display")
	public String sleepDisplay() {
		return "user/sleep";
	}
	
	@PostMapping("/user/restore")
	public void restore(HttpServletRequest request, HttpServletResponse response) {
		userService.restoreUSer(request, response);
	}
	
	@GetMapping("/user/naver/login")
	public String naverLogin(HttpServletRequest request, Model model) {
		
		String access_token = userService.getNaverLoginToken(request);
		UserDTO profile = userService.getNaverLoginProfile(access_token);  
		UserDTO naverUser = userService.getNaverUserById(profile.getId()); 
		
		if(naverUser == null) {
			model.addAttribute("profile", profile);
			return "user/naver_join";
		} else {
			userService.naverLogin(request, naverUser);
			return "redirect:/";
		}
		
	}
	
	@PostMapping("/user/naver/join")
	public void naverJoin(HttpServletRequest request, HttpServletResponse response) {
		userService.naverJoin(request, response);
	}
	
	@GetMapping("/user/findId")
	public String findId() {
		return "user/findId";
	}
	
	@ResponseBody
	@GetMapping(value="/user/isReduceFindEmail", produces=MediaType.APPLICATION_JSON_VALUE)
	public Map<String, Object> isReduceFindEmail(String email){
		return userService.isReduceFindEmail(email);
	}
	
	@ResponseBody
	@GetMapping(value="/user/findId/sendAuthCode", produces=MediaType.APPLICATION_JSON_VALUE)
	public Map<String, Object> FindIdByEmail(String email){
		return userService.findId(email);
	}
	
	@ResponseBody
	@GetMapping(value="/user/findPw/sendAuthCode", produces=MediaType.APPLICATION_JSON_VALUE)
	public Map<String, Object> FindPwByEmail(String email, String id){
		return userService.findpw(email, id);
	}
	
	@ResponseBody
	@PostMapping(value="/user/findPw/sendMailPw", produces=MediaType.APPLICATION_JSON_VALUE)
	public Map<String, Object> FindsendEmail(String email, String id){
		return userService.sendPw(email, id);
	}
	
	@GetMapping("user/findPw")
	public String findPw() {
		return "user/findPw";
	}

	
}
