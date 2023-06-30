package com.gdu.semi.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.semi.domain.FreeBoardDTO;

@Mapper
public interface FreeBoardMapper {
	public int selectAllFreeCount();
	public List<FreeBoardDTO> selectAllFreeList(Map<String, Object> map);
	public int insertFree(FreeBoardDTO freeBoard);
	public int updatePreviousReply(FreeBoardDTO freeBoard);
	public int insertReply(FreeBoardDTO freeBoard);
	public int deleteFree(int freeBoardNo);
	public int insertContent(FreeBoardDTO freeBoard);
	public FreeBoardDTO selectBoardByNo(int freeBoardNo);
	public int modifyFree(FreeBoardDTO freeBoard);
	
}
