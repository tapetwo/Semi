package com.gdu.semi.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.gdu.semi.domain.FreeBoardDTO;

public interface FreeBoardService {
	public void findAllFreeList(HttpServletRequest request, Model model);
	public int addFree(HttpServletRequest request);
	public int addReply(HttpServletRequest request);
	public int removeFree(int freeBoardNo);
	public FreeBoardDTO getFreeBoardByNo(int freeBoardNo);
	public void findFreeList(HttpServletRequest request, Model model);
	public int modifyFree(HttpServletRequest request);
}
