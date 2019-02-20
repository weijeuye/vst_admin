package com.lvmama.scenic.back.prod.po;

import java.io.Serializable;

/**
 * 属性VO
 * 2013-11-29
 * @version
 */
public class PropValue implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -8026512374891988326L;
	private Long id;
	private String name;
	private String addValue;
	private Long dictPropDefId;
	private String dictPropValue;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAddValue() {
		return addValue;
	}
	public void setAddValue(String addValue) {
		this.addValue = addValue;
	}
    public String getDictPropValue() {
        return dictPropValue;
    }
    public void setDictPropValue(String dictPropValue) {
        this.dictPropValue = dictPropValue;
    }
    public Long getDictPropDefId() {
        return dictPropDefId;
    }
    public void setDictPropDefId(Long dictPropDefId) {
        this.dictPropDefId = dictPropDefId;
    }
	@Override
	public String toString() {
		return name + (addValue==null?"":"（" + addValue + ")");
	}
	
	
}
