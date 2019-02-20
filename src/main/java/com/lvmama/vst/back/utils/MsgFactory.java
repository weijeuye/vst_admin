package com.lvmama.vst.back.utils;

import com.lvmama.vst.comm.utils.StringUtil;
import net.sf.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * 消息构造器
 *      Json 基本格式
 *
 *      {
 *          "objectId": objectId,
 *          "categoryId": 1234324
 *          "objectType": "PRODUCT",
 *          "operateType": "UP",
 *          "createMilTime": 3241234
 *      }
 */
/**
 *      Json 自由行打包组
 *      {
 *          "objectId": objectId,
 *          "categoryId": 1234324,
 *          "objectType": "PRODUCT",
 *
 *          "bizScope": "PROD_PRODUCT",
 *          "bizType": "bizType",
 *          "bizId": 34123432,      //groupId
 *          "relateInfo": 0809890,      //branchId
 *          "operateType": "DEL",
 *
 *          "createMilTime": 3241234
 *      }
 */
public class MsgFactory {

    private final Logger logger = LoggerFactory.getLogger(MsgFactory.class);

    private static MsgFactory msgBuilder = null;
    private MsgFactory(){}

    public static MsgFactory get(){
        if(msgBuilder == null){
            synchronized (MsgFactory.class){
                if(msgBuilder == null){
                    msgBuilder = new MsgFactory();
                }
            }
        }
        return msgBuilder;
    }

    /**
     * 私有的方法供其他方法调用
     * @param objectId
     * @param objectType
     * @param additionMap
     * @return
     */
    private String create(long objectId, Long categoryId, String objectType, String operateType,
                         Map<String, Object> additionMap){
        Map<String,Object> jsonMap = new HashMap<String, Object>();
        jsonMap.put("objectId", objectId);
        jsonMap.put("categoryId", categoryId);
        jsonMap.put("objectType", objectType);
        jsonMap.put("operateType", operateType);
        jsonMap.putAll(additionMap);
        jsonMap.put("createMilTime", System.currentTimeMillis());
        JSONObject jsonObject = JSONObject.fromObject(jsonMap);
        return jsonObject.toString();
    }

    /**
     * 默认的消息生成
     * @param objectId
     * @param objectType
     * @param bizId
     * @param bizType
     * @return
     */
    public String create4PackGroup(Long objectId,Long categoryId, String objectType, String bizScope, String bizId,
                                   String relateInfo, String bizType, String operateType){
        Map<String,Object> additionMap = new HashMap<String, Object>();
        additionMap.put("bizScope",bizScope);
        additionMap.put("bizId",bizId);
        additionMap.put("relateInfo",relateInfo);
        additionMap.put("bizType",bizType);
        return this.create(objectId,categoryId,objectType,operateType,additionMap);
    }

    /**
     *  将Json转换成Map
     * @param json
     * @return
     */
    public Map<String,Object> toMap(String json){
        if(StringUtil.isEmptyString(json)){
            return Collections.emptyMap();
        }
        Map<String,Object> jsonMap = new HashMap<String,Object>();
        try {
            JSONObject jsonObject = JSONObject.fromObject(json);
            jsonMap.putAll(jsonObject);
        }catch (Exception e){
            logger.error(e.getMessage());
        }
        return jsonMap;
    }

}
