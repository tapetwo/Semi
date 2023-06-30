package com.gdu.semi.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gdu.semi.domain.CommentDTO;
import com.gdu.semi.service.CommentService;

@Controller
public class CommentController {
	
	@Autowired
	private CommentService commentService;
	
	@ResponseBody
	@GetMapping(value="/comment/getCount", produces="application/json")
	public Map<String, Object> getCount(@RequestParam("galleryBoardNo") int galleryBoardNo) {
		return commentService.getCommentCount(galleryBoardNo);
	}
	
	@ResponseBody
	@PostMapping(value="/comment/add", produces="application/json")
	public Map<String, Object> add(CommentDTO comment, HttpServletRequest request) {
		return commentService.addComment(comment,request);
	}
	
	@ResponseBody
	@GetMapping(value="/comment/list", produces="application/json")
	public Map<String, Object> list(HttpServletRequest request) {
		return commentService.getCommentList(request);
	}
	
	@ResponseBody
	@PostMapping(value="/comment/remove", produces="application/json")
	public Map<String, Object> remove(@RequestParam("commentsNo") int commentsNo){
		return commentService.removeComment(commentsNo);
	}
	
	@ResponseBody
	@PostMapping(value="/comment/reply/add", produces="application/json")
	public Map<String, Object> replyAdd(CommentDTO reply, HttpServletRequest request){
		return commentService.addReply(reply, request);
	}
	
}
