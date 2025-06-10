package com.example.demo.dao;

import java.util.*;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.example.demo.model.MemVo;

@Repository
public class MemDao {

	@Autowired
	private SqlSession sqlsession;

	public void insertMember(MemVo vo) {
		sqlsession.insert("MemMapper.insertMember", vo);
	}

	public List<MemVo> selectMembers() {
		return sqlsession.selectList("MemMapper.selectMembers");
	}

	public void updateMember(MemVo vo) {
		sqlsession.update("MemMapper.updateMember", vo);
	}

	public void deleteMember(int member_no) {
		sqlsession.delete("MemMapper.deleteMember", member_no);
	}

	public MemVo selectMemView(int member_no) {
		return sqlsession.selectOne("MemMapper.selectMemView", member_no);
	}

	public MemVo memLogin(String member_id, String member_pwd) {
		return sqlsession.selectOne("MemMapper.memLogin", member_id);
	}

	public MemVo getMember(String member_id) {
		return sqlsession.selectOne("MemMapper.getMember", member_id);
	}

	public MemVo getCount(String member_id) {
		return sqlsession.selectOne("MemMapper.getCount", member_id);
	}

	public MemVo selectMemId(String member_id) {
		return sqlsession.selectOne("MemMapper.selectMemId", member_id);
	}

}
