package com.gdu.semi.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.gdu.semi.service.GalleryBoardService;

@Controller
public class GalleryBoardController {
	
	
	@Autowired
	private GalleryBoardService galleryBoardService;
	
	@GetMapping("/gallery/list")
	public String list(HttpServletRequest request, Model model) {
		model.addAttribute("request", request);  // model에 request를 저장하기
		galleryBoardService.getGalleryBoardList(model); // model만 넘기지만 이미 model에는 request가 들어 있음
		return "gallery/list";
				
	}
	
	
	
	@GetMapping("/gallery/write")
	public String write() {
		return "gallery/write";
		
	}
	
	@ResponseBody
	@PostMapping(value="/gallery/uploadImage", produces="application/json")
	public Map<String, Object> uploadImage(MultipartHttpServletRequest multipartRequest) {
		return galleryBoardService.saveSummernoteImage(multipartRequest);
	}
	
	
	
	@PostMapping("/gallery/add")
	public void add(HttpServletRequest request, HttpServletResponse response) {
			galleryBoardService.saveGalleryBoard(request, response);
			
	}
	
	@GetMapping("/gallery/increse/hit")
	public String increseHit(@RequestParam(value="galleryBoardNo", required=false, defaultValue="0") int galleryBoardNo) {
			int result =galleryBoardService.increseGalleryBoardHit(galleryBoardNo);
			if(result > 0) { 
					return "redirect:/gallery/detail?galleryBoardNo=" + galleryBoardNo;
			}else { 
				 	return "redirect:/gallery/list";
			}
}
	
	@GetMapping("/gallery/detail")
	public String detail(@RequestParam(value="galleryBoardNo",required=false, defaultValue="0") int galleryBoardNo, Model model) {
		System.out.println(galleryBoardNo);
		model.addAttribute("galleryBoard", galleryBoardService.getGalleryBoardByNo(galleryBoardNo));
		return "gallery/detail";
	}
	
	@PostMapping("/gallery/edit")
	public String edit(int galleryBoardNo, Model model) {
		model.addAttribute("galleryBoard", galleryBoardService.getGalleryBoardByNo(galleryBoardNo));
		return "gallery/edit";
	}
	
	
	@PostMapping("/gallery/modify")
	public void modify(HttpServletRequest request, HttpServletResponse response) {
		galleryBoardService.modifyGalleryBoard(request, response);
	}
	
	@PostMapping("/gallery/remove")
	public void remove(HttpServletRequest request, HttpServletResponse response) {
		galleryBoardService.removeGalleryBoard(request, response);
	}
	

}