package com.gdu.semi.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gdu.semi.domain.CommentDTO;
import com.gdu.semi.mapper.CommentMapper;
import com.gdu.semi.util.PageUtil;


@Service
public class CommentServiceImpl implements CommentService {
	
	
	 
	@Autowired
	private CommentMapper commentMapper;
	
	@Autowired
	private PageUtil pageUtil;
	
	@Override
	public Map<String, Object> getCommentCount(int galleryBoardNo){
		Map<String, Object> result=new HashMap<String, Object>();
		result.put("commentCount", commentMapper.selectCommentCount(galleryBoardNo));
		return result;
	}

	@Override
	public Map<String, Object> addComment(CommentDTO comment, HttpServletRequest request) {
		String ip = request.getRemoteAddr();         
        comment.setIp(ip);
		Map<String, Object> result=new HashMap<String, Object>();
		result.put("isAdd", commentMapper.insertComment(comment)==1);
		return result;
		
	}
	
	
	@Override
	public Map<String, Object> getCommentList(HttpServletRequest request) {
		
		int galleryBoardNo =Integer.parseInt(request.getParameter("galleryBoardNo"));
		int page=Integer.parseInt(request.getParameter("page"));
		
		int commentCount=commentMapper.selectCommentCount(galleryBoardNo);
		pageUtil.setPageUtil(page, commentCount);
		
		Map<String, Object> map= new HashMap<String, Object>();
		map.put("galleryBoardNo", galleryBoardNo);
		map.put("begin", pageUtil.getBegin());
		map.put("end", pageUtil.getEnd());
		
		Map<String, Object> result= new HashMap<String, Object>();
		result.put("commentList", commentMapper.selectCommentList(map));
		System.out.println(commentMapper.selectCommentList(map));
		result.put("pageUtil", pageUtil);
		
		return result;
	}
	
	
	@Override
	public Map<String, Object> removeComment(int commentsNo) {
		Map<String, Object> result= new HashMap<String, Object>();
		result.put("isRemove", commentMapper.deleteComment(commentsNo)==1);
		return result;
	}
	
	
	@Override
	public Map<String, Object> addReply(CommentDTO reply, HttpServletRequest request) {
		String ip = request.getRemoteAddr();         
        reply.setIp(ip);
		Map<String, Object> result= new HashMap<String, Object>();
		result.put("isAdd", commentMapper.insertReply(reply)==1);
		return result;
	}
	
	
}
	
	
