package com.gdu.semi.domain;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class BoardDTO {
	private int rn;
	private int freeBoardNo;
	private int galleryBoardNo;
	private int uploadBoardNo;
	private String id;
	private String title;
	private String content;
	private String ip;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date createDate;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date modifyDate;
	private int state;
	private int depth;
	private int groupNo;
	private int groupOrder;
	private int hit;
}
