package com.gdu.semi.domain;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class UploadBoardDTO {
	private int uploadBoardNo;
	private String id;
	private String uploadTitle;
	private String uploadContent;
	private String ip;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date createDate;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date modifyDate;
	private int hit;
	private int attachCnt;
	
}
