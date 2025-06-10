package com.example.demo.service;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.dao.MemDao;
import com.example.demo.mapper.MemMapper;
import com.example.demo.model.MemVo;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;

import io.micrometer.common.util.StringUtils;

@Service
@Transactional
public class MemService {
	@Autowired
	private MemDao dao;
	@Autowired
	private MemMapper m;
	
	public void insertMember(MemVo vo) {
		System.out.println("실행된거임" + vo);
		m.insertMember(vo);
	}

	public List<MemVo> selectMembers() {
		return m.selectMembers();
	}

	public void updateMember(MemVo vo) {
		m.updateMember(vo);
	}

	public void deleteMember(int memberNo) {
		m.deleteMember(memberNo);
	}

	public void savePost(MemVo vo) {
		m.insertMember(vo);
	}

	public MemVo selectMemView(int memberNo) {
		return m.selectMemView(memberNo);

	}

	public String memLogin(String memberId, String memberPwd) {
		if (StringUtils.isBlank(memberId) || StringUtils.isBlank(memberPwd)) {
			return null;
		}

		MemVo vo = m.memLogin(memberId, memberPwd);

		if (vo == null) {
			System.out.println("등록되지 않은 회으ㅏㄴ" + memberId);
			return null;
		}

		if (vo.getMember_pwd() == null) {
			return null;
		}

		if (vo.getMember_pwd().equals(memberPwd)) {
			System.out.println("로그인성공" + vo.getMember_id() + "님");
			return vo.getMember_id();
		} else {
			System.out.println("비번틀림");
			return null;
		}
	}

	public MemVo getMember(String memberId) {
		return m.getMember(memberId);
	}

	public MemVo getCount(String memberId) {
		return m.getCount(memberId);
	}

	public MemVo selectMemId(String memberId) {
		return m.selectMemId(memberId);
	}

	@Value("${google.client.id}")
	private String googleClientId;

	private static final HttpTransport transport = new NetHttpTransport();
	private static final JsonFactory jsonFactory = new GsonFactory();

	public GoogleIdToken.Payload verifyGoogleToken(String googleToken) {
		GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(transport, jsonFactory)
				.setAudience(Collections.singletonList(googleClientId)).build();
		try {
			GoogleIdToken idToken = verifier.verify(googleToken);
			if (idToken != null) {
				return idToken.getPayload();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public MemVo selectGoogle(String googleSub) {
		return m.selectGoogle(googleSub);
	}

	public void insertGoogle(MemVo vo) {
		m.insertGoogle(vo);
	}

	public boolean IdAvailable(String memberId) {
		return m.selectMemId(memberId)==null;
	}
}
