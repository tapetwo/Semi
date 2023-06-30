package com.gdu.semi.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface UploadBoardService {
	
	public ResponseEntity<Object> getUpLoadList(int pageNo);
	public ResponseEntity<Object> getFindUploadList(HttpServletRequest request);
	public ResponseEntity<Object> save(MultipartHttpServletRequest multipartHttpServletRequest, HttpServletResponse response);
	
	public int increaseHit(int uploadBoardNo);
	public ResponseEntity<Object>  getUploadByNo(int uploadBoardNo);
	
	public ResponseEntity<Resource> download(String userAgent, int attachNo);
	public ResponseEntity<Resource> downloadAll(String userAgent, int uploadBoardNo);
	public ResponseEntity<Object> usePoint(HttpServletRequest request);
	
	public ResponseEntity<Object> modifyUpload(MultipartHttpServletRequest mulRequest, HttpServletResponse response);
	
	public ResponseEntity<Object> removeAttachByAttachNo(int attachNo);
	
	public ResponseEntity<Object> removeUpload(HttpServletRequest request,HttpServletResponse response );
}
