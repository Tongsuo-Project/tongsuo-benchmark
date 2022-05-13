/******************************************/
/*   DatabaseName = babassl-benchmark   */
/*   TableName = digest   */
/******************************************/
CREATE TABLE `digest` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `last_commit` char(64) DEFAULT NULL COMMENT '最后一次提交的 commit',
  `my_commit` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '本条记录提交的 commit',
  `algorithm` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '算法',
  `bytes16` bigint DEFAULT NULL,
  `bytes64` bigint DEFAULT NULL,
  `bytes256` bigint DEFAULT NULL,
  `bytes1024` bigint DEFAULT NULL,
  `bytes8192` bigint DEFAULT NULL,
  `bytes16384` bigint DEFAULT NULL,
  `date` datetime DEFAULT NULL COMMENT '测试时间',
  `job_date` datetime DEFAULT NULL COMMENT 'job 运行时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 COMMENT='摘要算法性能数据'
;

/******************************************/
/*   DatabaseName = babassl-benchmark   */
/*   TableName = key_exchange   */
/******************************************/
CREATE TABLE `key_exchange` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `last_commit` char(64) DEFAULT NULL COMMENT '最后一次提交的 commit',
  `my_commit` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '本条记录提交的 commit',
  `algorithm` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '算法',
  `op_time` decimal(10,6) DEFAULT NULL,
  `op_qps` decimal(10,1) DEFAULT NULL,
  `date` datetime DEFAULT NULL COMMENT '测试时间',
  `job_date` datetime DEFAULT NULL COMMENT 'job 运行时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3 COMMENT='密钥交换算法性能数据'
;

/******************************************/
/*   DatabaseName = babassl-benchmark   */
/*   TableName = phe   */
/******************************************/
CREATE TABLE `phe` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `last_commit` char(64) DEFAULT NULL COMMENT '最后一次提交的 commit',
  `my_commit` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '本条记录提交的 commit',
  `algorithm` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '算法',
  `a` int DEFAULT NULL COMMENT '明文 a',
  `b` int DEFAULT NULL COMMENT '明文 b',
  `encrypt_qps` decimal(10,1) DEFAULT NULL,
  `decrypt_qps` decimal(10,1) DEFAULT NULL,
  `add_qps` decimal(10,1) DEFAULT NULL,
  `sub_qps` decimal(10,1) DEFAULT NULL,
  `scalar_mul_qps` decimal(10,1) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `job_date` datetime DEFAULT NULL COMMENT 'job 运行时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb3 COMMENT='半同态加密算法性能数据'
;

/******************************************/
/*   DatabaseName = babassl-benchmark   */
/*   TableName = signature   */
/******************************************/
CREATE TABLE `signature` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `last_commit` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '最后提交一次的 commit',
  `my_commit` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '本条记录提交的 commit',
  `algorithm` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '算法',
  `sign_time` decimal(10,6) DEFAULT NULL COMMENT '签名时间，单位：s',
  `verify_time` decimal(10,6) DEFAULT NULL COMMENT '验签时间，单位：s',
  `sign_qps` decimal(10,1) DEFAULT NULL COMMENT '签名 qps',
  `verify_qps` decimal(10,1) DEFAULT NULL COMMENT '验签 qps',
  `date` datetime DEFAULT NULL COMMENT '测试时间',
  `job_date` datetime DEFAULT NULL COMMENT 'job 运行时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3 COMMENT='签名算法性能数据'
;

/******************************************/
/*   DatabaseName = babassl-benchmark   */
/*   TableName = symmetric_encryption   */
/******************************************/
CREATE TABLE `symmetric_encryption` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `last_commit` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '最后一次提交的 commit',
  `my_commit` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '本条记录提交的 commit',
  `algorithm` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '算法',
  `bytes16` bigint DEFAULT NULL,
  `bytes64` bigint DEFAULT NULL,
  `bytes256` bigint DEFAULT NULL,
  `bytes1024` bigint DEFAULT NULL,
  `bytes8192` bigint DEFAULT NULL,
  `date` datetime DEFAULT NULL COMMENT '测试时间',
  `job_date` datetime DEFAULT NULL COMMENT 'job 运行时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb3 COMMENT='对称加密性能数据'
;
