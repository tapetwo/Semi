package com.gdu.semi.domain;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDTO {
	private int userNo;
	private String id;
	private String pw;
	private String name;
	private String gender;
	private String email;
	private String mobile;
	private String birthyear;
	private String birthday;
	private String postcode;
	private String roadAddress;
	private String jibunAddress;
	private String detailAddress;
	private String extraAddress;
	private int agreeCode;
	private String snsType;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date joinDate;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date pwModifyDate;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date infoModifyDate;
	private String sessionId;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date sessionLimitDate;
	private int point;
	private AccessLogDTO accessLogDTO;
}