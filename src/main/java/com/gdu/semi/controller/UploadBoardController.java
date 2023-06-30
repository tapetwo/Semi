package com.gdu.semi.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.gdu.semi.service.UploadBoardService;

@Controller
public class UploadBoardController {

	@Autowired
	private UploadBoardService uploadBoardService;

	
	@GetMapping("/upload/list")
	public String list(@RequestParam(value = "pageNo", required = false, defaultValue = "1") int pageNo, Model model) {
		model.addAttribute("pageNo", pageNo);
		return "upload/list";
		
	}
	
	
	@ResponseBody
	@GetMapping(value = "/upload/search", produces="application/json; charset=UTF-8")
	public  ResponseEntity<Object> search(HttpServletRequest request , @RequestParam(value = "pageNo", required = false, defaultValue = "1") int pageNo) { 
		return uploadBoardService.getFindUploadList(request); 
	}
	 

	@ResponseBody
	@GetMapping(value = "/upload/ulist", produces="application/json; charset=UTF-8")
	public ResponseEntity<Object> jsonList(@RequestParam(value = "pageNo", required = false, defaultValue = "1") int pageNo ) {
		return uploadBoardService.getUpLoadList(pageNo);
	}

	@GetMapping("/upload/write")
	public String write() {
		return "upload/write";
	}
	
	@ResponseBody
	@PostMapping("/upload/add")
	public ResponseEntity<Object> add(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) {
		return uploadBoardService.save(multipartRequest, response);
	}
	
	@GetMapping("/upload/detail")
	public String detail(@RequestParam(value = "uploadBoardNo", required = false, defaultValue = "0")int uploadBoardNo, Model model) {
		model.addAttribute("uploadBoardNo", uploadBoardNo );
		return "upload/detail";
	}
	
	@GetMapping("/upload/incrase/hit")
	public String incraseHit(@RequestParam(value = "uploadBoardNo", required = false, defaultValue = "0")int uploadBoardNo) {
		int result = uploadBoardService.increaseHit(uploadBoardNo);
		if(result > 0 ) {
			return "redirect:/upload/detail?uploadBoardNo=" + uploadBoardNo;
		} else {
			return "redirect:/upload/list";
		}
	}
	
	
	@ResponseBody
	@GetMapping("/upload/detail/ulist")
	public ResponseEntity<Object> detailList(@RequestParam(value = "uploadBoardNo", required = false, defaultValue = "0")int uploadBoardNo ){
		return uploadBoardService.getUploadByNo(uploadBoardNo);
	}
	
	@PostMapping("/upload/usePoint")
	public ResponseEntity<Object> usePoint(HttpServletRequest request) {
		 return uploadBoardService.usePoint(request);
	}
	
	@ResponseBody
	@GetMapping("/upload/download")
	public ResponseEntity<Resource> download(@RequestHeader("User-Agent") String userAgent, @RequestParam("attachNo") int attachNo){
		return uploadBoardService.download(userAgent, attachNo);
	}
	
	@ResponseBody
	@GetMapping("/upload/downloadAll")
	public ResponseEntity<Resource> downloadAll(@RequestHeader("User-Agent") String userAgent, @RequestParam("uploadBoardNo") int uploadBoardNo){
		return uploadBoardService.downloadAll(userAgent, uploadBoardNo);
	}
	
	

	@PostMapping("/upload/edit")
	public String edit(@RequestParam("uploadBoardNo") int uploadBoardNo, Model model) {
		model.addAttribute("edit", uploadBoardService.getUploadByNo(uploadBoardNo).getBody() );
		return "upload/edit";
	}
	
	@ResponseBody
	@PostMapping("/upload/uedit")
	public ResponseEntity<Object> uedit(@RequestParam("uploadBoardNo") int uploadBoardNo, Model model){
//		model.addAttribute("edit", uploadBoardService.getUploadByNo(uploadBoardNo).getBody() );
		return new ResponseEntity<Object>( uploadBoardService.getUploadByNo(uploadBoardNo).getBody(),HttpStatus.OK);
	}
	
	
	@ResponseBody
	@PostMapping("/upload/uModify")
	public ResponseEntity<Object> modify(MultipartHttpServletRequest mulRequest, HttpServletResponse response) {
		return uploadBoardService.modifyUpload(mulRequest, response);
	}
	
	
	
	@ResponseBody
	@PostMapping("/upload/attach/remove")
	public ResponseEntity<Object> attachRemove(@RequestParam("attachNo") int attachNo){
		return uploadBoardService.removeAttachByAttachNo(attachNo);
	}
	
	
	@PostMapping("/upload/remove")
	public ResponseEntity<Object> remove(HttpServletRequest request, HttpServletResponse response) {
		return uploadBoardService.removeUpload(request, response);
	}
	
}
