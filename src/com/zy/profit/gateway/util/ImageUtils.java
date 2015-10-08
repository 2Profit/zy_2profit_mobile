package com.zy.profit.gateway.util;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.imageio.ImageIO;

import org.apache.commons.io.FileUtils;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGEncodeParam;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

public class ImageUtils {

	public static String saveHeadImage(InputStream is,String filePath){
		int width = 160;
		int height = 160;
		float quality = 1f;
		return zipWidthHeightImageFile(is, filePath, width, height, quality);
	}
	
	/**
     * 按宽度高度压缩图片文件<br> 先保存原文件，再压缩、上传
     * @param oldFile  要进行压缩的文件全路径
     * @param newFile  新文件
     * @param width  宽度
     * @param height 高度
     * @param quality 质量
     * @return 返回压缩后的文件的全路径
     */ 
    public static String zipWidthHeightImageFile(InputStream is,String filePath, int width, int height, 
            float quality) { 
        if (is == null) { 
            return null; 
        } 
        
        File file = FileUtils.getFile(filePath);
        
        String newImage = null; 
        try { 
            /** 对服务器上的临时文件进行处理 */ 
            Image srcFile = ImageIO.read(is);
//            int w = srcFile.getWidth(null); 
//            int h = srcFile.getHeight(null); 
   
            /** 宽,高设定 */ 
            BufferedImage tag = new BufferedImage(width, height,BufferedImage.TYPE_INT_RGB); 
            tag.getGraphics().drawImage(srcFile, 0, 0, width, height, null); 
   
            /** 压缩之后临时存放位置 */ 
            FileOutputStream out = new FileOutputStream(file); 
   
            JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out); 
            JPEGEncodeParam jep = JPEGCodec.getDefaultJPEGEncodeParam(tag); 
            /** 压缩质量 */ 
            jep.setQuality(quality, true); 
            encoder.encode(tag, jep); 
            out.close(); 
        } catch (FileNotFoundException e) { 
            e.printStackTrace(); 
        } catch (IOException e) { 
            e.printStackTrace(); 
        } 
        return newImage; 
    }
	
}
