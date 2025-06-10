package com.example.demo.dao;

import java.util.*;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.demo.model.MemVo;
import com.example.demo.model.ReVo;

@Repository
public class ReDao {

	@Autowired
	private SqlSession sqlsession;

	public void insertReply(ReVo vo) {
		sqlsession.insert("ReMapper.insertReply", vo);
	}

	public List<ReVo> selectReplys() {
		return sqlsession.selectList("ReMapper.selectReplys");
	}

	public void updateReply(ReVo vo) {
		sqlsession.update("ReMapper.updateReply", vo);
	}

	public void deleteReply(int reply_no) {
		sqlsession.delete("ReMapper.deleteReply", reply_no);
	}

	public ReVo selectReView(int reply_no) {
		return sqlsession.selectOne("ReMapper.selectReView", reply_no);
	}

	public MemVo getMemId(String member_id) {
		return sqlsession.selectOne("ReMapper.getMemId", member_id);
	}
}
