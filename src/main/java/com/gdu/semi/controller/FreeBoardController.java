package com.gdu.semi.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gdu.semi.service.FreeBoardService;

@Controller
public class FreeBoardController {
	
	@Autowired
	private FreeBoardService freeBoardService;
	
	@GetMapping("/free/list")
	public String list(HttpServletRequest request, Model model) {
		freeBoardService.findAllFreeList(request, model);
		return "free/list";
	}
	
	@GetMapping("/free/write")
	public String write() {
		return "free/write";
	}
	
	@PostMapping("/free/add")
	public String add(HttpServletRequest request) {
		freeBoardService.addFree(request);
		return "redirect:/free/list";
	}
	
	@PostMapping("/free/remove")
	public String remove(@RequestParam("freeBoardNo") int freeBoardNo) {
		freeBoardService.removeFree(freeBoardNo);
		return "redirect:/free/list";
	}
	
	@PostMapping("/free/reply/add")
	public String replyAdd(HttpServletRequest request) {
		freeBoardService.addReply(request);
		return "redirect:/free/list";
	}
	
	@GetMapping("/free/edit")
	public String content(@RequestParam("freeBoardNo") int freeBoardNo, Model model) {
		model.addAttribute("free", freeBoardService.getFreeBoardByNo(freeBoardNo));
		return "free/edit";
	}
	
	@PostMapping("/free/modify")
	public String modify(HttpServletRequest request) {
		System.out.println("modify:" + request.getParameter("freeBoardNo") );
		freeBoardService.modifyFree(request);
		return "redirect:/free/list";
	}
	
	
	
	
}
