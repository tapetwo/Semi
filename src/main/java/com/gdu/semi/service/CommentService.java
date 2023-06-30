package com.gdu.semi.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.gdu.semi.domain.CommentDTO;

public interface CommentService {
	   public Map<String, Object> getCommentCount(int galleryBoardNo);
	   public Map<String, Object> addComment(CommentDTO comment, HttpServletRequest request);
	   public Map<String, Object> getCommentList(HttpServletRequest request);
	   public Map<String, Object> removeComment(int commentsNo);
	   public Map<String, Object> addReply(CommentDTO reply, HttpServletRequest request);
	   
}