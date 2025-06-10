package com.example.demo.mapper;

import com.example.demo.model.MemVo;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface MemMapper {
	List<MemVo> selectMembers();

	void insertMember(MemVo vo);

	void updateMember(MemVo vo);

	void deleteMember(int memberNo);

	MemVo selectMemView(int memberNo);

	MemVo memLogin(String memberId, String memberPwd);

	MemVo getMember(String memberId);

	MemVo getCount(String memberId);

	MemVo selectMemId(String memberId);

	MemVo selectGoogle(String googleSub);

	void insertGoogle(MemVo vo);
}