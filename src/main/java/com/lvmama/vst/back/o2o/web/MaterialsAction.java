package com.lvmama.vst.back.o2o.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.lvmama.comm.pet.fs.client.FSClient;
import com.lvmama.vst.back.client.o2o.service.MaterialsClientService;
import com.lvmama.vst.back.o2o.po.Materials;
import com.lvmama.vst.back.utils.Constants;
import com.lvmama.vst.comm.vo.ResultMessage;
import com.lvmama.vst.comm.web.BaseActionSupport;
import com.lvmama.vst.comm.web.BusinessException;

@Controller
@RequestMapping("/o2o")
public class MaterialsAction extends BaseActionSupport {

    private static final long serialVersionUID = -8229659893190367057L;
    private static final Logger LOGGER = LoggerFactory.getLogger(MaterialsAction.class);

    @Autowired
    private FSClient vstFSClient;

    @Autowired
    private MaterialsClientService materialsService;

    /**
     * 批量上传资质
     * 
     * @param
     * @return
     */
    @RequestMapping(value = "/materials")
    @ResponseBody
    public Object uploadMaterials(MultipartHttpServletRequest req, String parentType, Long parentId, Long subCompanyId,
            @RequestParam(value = "delIds[]", required = false) List<Long> delIds, HttpServletResponse res,
            String serverType) throws Exception {
        LOGGER.info("start method<MaterialsAction#uploadMaterials>");
        if (LOGGER.isInfoEnabled()) {
            LOGGER.info("parentType:" + parentType + ";parentId:" + parentId + ";delIds:" + delIds);
        }

        if (StringUtils.isEmpty(serverType)) {
            LOGGER.error("Invalid server type.");
            return new ResultMessage(ResultMessage.ERROR, "服务类型不存在");
        }
        List<MultipartFile> tempMaterialsList = req.getFiles("materials");
        List<MultipartFile> tempInternalFileList = req.getFiles("internalFile");
        List<Materials> materialsList = new ArrayList<Materials>();
        try {
            for (MultipartFile file : tempMaterialsList) {
                if(file.getSize() == 0) {
                    continue;
                }
                Materials object = new Materials();
                uploadFile(file, serverType, object);
                object.setInternalFlag(Constants.INVALID_STATUS);
                object.setObjectId(parentId);
                object.setObjectType(parentType);
                materialsList.add(object);
            }
            for (MultipartFile file : tempInternalFileList) {
                if(file.getSize() == 0) {
                    continue;
                }
                Materials object = new Materials();
                uploadFile(file, serverType, object);
                object.setInternalFlag(Constants.VALID_STATUS);
                object.setObjectId(parentId);
                object.setObjectType(parentType);
                materialsList.add(object);
            }
            // 将上传好的数据文件名等保存到数据库，如果delIds存在则删除这个List中包含的数据
            materialsService.updateMaterials(materialsList, delIds, this.getLoginUserId(), parentType, parentId, subCompanyId);
        } catch (Exception e) {
            LOGGER.error("Error occurred while uploading materials.", e);
            return new ResultMessage(ResultMessage.ERROR, "系统内部异常");
        }
        return new ResultMessage(ResultMessage.SUCCESS, "保存成功");
    }

    /**
     * 获得资质列表
     * 
     * @param model
     * @param param
     * @param req
     * @return
     * @throws BusinessException
     */
    @RequestMapping(value = "/showMaterials")
    public String findMaterialsList(Model model, String param, String auditType, HttpServletRequest req)
            throws BusinessException {
        LOGGER.info("start method<MaterialsAction#findMaterialsList>");
        if (LOGGER.isInfoEnabled()) {
            LOGGER.info("param is " + param + ";auditType is " + auditType);
        }
        Map<String, Object> paramsMap = new HashMap<String, Object>();
        try {
            if (null != param && !"".equals(param)) {
                JSONObject jsonObject = JSONObject.fromObject(param);
                for (Iterator<?> iter = jsonObject.keys(); iter.hasNext();) {
                    String key = (String) iter.next();
                    String value = jsonObject.get(key).toString();
                    paramsMap.put(key, value);
                }
            }
            Map<String, List<Materials>> resultMap = materialsService.findAllMaterialsByParams(paramsMap).getReturnContent();
            // 将请求参数放在model里。
            for (String key : paramsMap.keySet()) {
                model.addAttribute(key, paramsMap.get(key));
            }

            List<Materials> materialsList = new ArrayList<Materials>();
            List<Materials> internalFileList = new ArrayList<Materials>();
            List<Long> materialsIds = new ArrayList<Long>();
            if (resultMap.containsKey("materialsList")) {
                for (Materials materials : resultMap.get("materialsList")) {
                    if (Constants.VALID_STATUS.equalsIgnoreCase(materials.getInternalFlag())) {
                        internalFileList.add(materials);
                    } else {
                        materialsList.add(materials);
                    }
                    materialsIds.add(materials.getId());
                }
            }
            model.addAttribute("materialsIds", materialsIds);
            model.addAttribute("materialsList", materialsList);
            model.addAttribute("internalFileList", internalFileList);
            if (resultMap.containsKey("oldMaterialsList")) {
                List<Materials> oldMaterialsList = new ArrayList<Materials>();
                List<Materials> oldInternalFileList = new ArrayList<Materials>();
                for (Materials materials : resultMap.get("oldMaterialsList")) {
                    if (Constants.VALID_STATUS.equalsIgnoreCase(materials.getInternalFlag())) {
                        oldInternalFileList.add(materials);
                    } else {
                        oldMaterialsList.add(materials);
                    }
                }
                model.addAttribute("oldMaterialsList", oldMaterialsList);
                model.addAttribute("oldInternalFileList", oldInternalFileList);
            }
        } catch(Exception e) {
            LOGGER.error("Error occurred while show materials", e);
            model.addAttribute("errorMsg", "系统内部异常");
        }
        model.addAttribute("auditType", auditType);
        return "/o2o/showMaterials";
    }

    private void uploadFile(MultipartFile file, String serverType, Materials object) throws IOException, Exception {
        LOGGER.debug("start upload file.");
        String fileName = file.getOriginalFilename();
        if (file.getSize() > 18874368L) {
            throw new IllegalArgumentException("文件不可以大于18M");
        }
        Long pid = vstFSClient.uploadFile(fileName, file.getBytes(), serverType);
        if (pid == 0) {
            throw new IllegalArgumentException("上传文件失败");
        }
        object.setFileId(pid);
        object.setName(fileName);
    }
}
