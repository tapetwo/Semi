package com.gdu.semi.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gdu.semi.service.AdminService;

@Controller
public class AdminController {
	
	@Autowired
	private AdminService adminService;
	
	
	@GetMapping("/admin/list/user")
	public String User() {
		return "admin/list/user";
	}
	
	@GetMapping("/admin/user/detail")
	public String UserDetail(HttpServletRequest request, Model model) {
		model.addAttribute("id", request.getParameter("id"));
		model.addAttribute("type", request.getParameter("type"));
		model.addAttribute("state", request.getParameter("state"));
		return "admin/list/detail";
	}
	
	@ResponseBody
	@GetMapping(value="/admin/list/allUsers", produces="application/json; charset=UTF-8")
	public Map<String, Object> userList(HttpServletRequest request){
		return adminService.findAllUsers(request);
	}
	
	@ResponseBody
	@GetMapping(value="/admin/list/searchUsers", produces="application/json; charset=UTF-8")
	public Map<String, Object> searchUserList(HttpServletRequest request){
		return adminService.findUsers(request);
	}
	
	@GetMapping("/admin/list/board")
	public String board(HttpServletRequest request) {
		return "admin/list/board";
	}
	
	@ResponseBody
	@PostMapping(value="/admin/user/retire", produces="application/json; charset=UTF-8")
	public Map<String, Object> retireUser(HttpServletRequest request) {
		return adminService.retireUser(request);
	}
	
	@ResponseBody
	@PostMapping(value="/admin/user/restore", produces="application/json; charset=UTF-8")
	public Map<String, Object> restoreUser(HttpServletRequest request) {
		return adminService.restoreUser(request);
	}
	
	@ResponseBody
	@PostMapping(value="/admin/user/dormant", produces="application/json; charset=UTF-8")
	public Map<String, Object> dormantUser(HttpServletRequest request) {
		return adminService.dormantUser(request);
	}
	
	@ResponseBody
	@GetMapping(value="/admin/list/allBoards", produces="application/json; charset=UTF-8")
	public Map<String, Object> boardList(HttpServletRequest request) {
		return adminService.findAllBoards(request);
	}
	
	@ResponseBody
	@GetMapping(value="/admin/list/searchBoards", produces="application/json; charset=UTF-8")
	public Map<String, Object> searchBoardList(HttpServletRequest request) {
		return adminService.findBoards(request);
	}
	
	@ResponseBody
	@PostMapping(value="/admin/board/remove", produces="application/json; charset=UTF-8")
	public Map<String, Object> removeBoards(@RequestParam(value="id[]") List<String> id, @RequestParam(value="boardNo[]") List<String> boardNo, @RequestParam(value="board[]") List<String> board) {
		return adminService.deleteBoard(id, boardNo, board);
	}
	
	@ResponseBody
	@GetMapping(value="/admin/list/allBoards/id", produces="application/json; charset=UTF-8")
	public Map<String, Object> BoardListById(HttpServletRequest request) {
		return adminService.findAllBoardsFromId(request);
	}
	
	@ResponseBody
	@GetMapping(value="/admin/search/boards/id", produces="application/json; charset=UTF-8")
	public Map<String, Object> searchBoardListById(HttpServletRequest request) {
		return adminService.findBoardsFromId(request);
	}
	
}
