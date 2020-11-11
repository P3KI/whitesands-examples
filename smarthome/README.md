# Smarthome Demo


## Example run

```
$ ./smarthome.sh 




-- ACT 0: Setup ------------------------------------------

# Querying required instances...

 Whitesands: Pong
      owner: i1, Pong
     friend: i2, Pong
global view: i3, Pong

# Resetting instances ...

      owner: "Instance reset executed"
     friend: "Instance reset executed"
global view: "Instance reset executed"

# Creating identities...

 owner: "AAAB0ucvUnYeNvtohYhj32ZYmfUgK10YvPlgLVS5ufPq5Tw"
  door: "AAABW1MY29aeIcvTEOR9kA6_y5kvw0-IFF2RrXQ1JBO7A4g"
heater: "AAABfNVMHuW4TGXFVtJU2eCqf_yZFQE6J3dPXknpVxJaaIY"
 light: "AAAB1y-EtHHv2M5SICIrrXiFP9shThBKNTVIS1ZN-S_3oeE"
friend: "AAABBEAPV19tXKZitG5IV8hwqWgLH8YXZN6o9d9khV4Hd1U"

# Requesting public keys...

 owner: AAAB0ucvUnYeNvtohYhj32ZYmfUgK10YvPlgLVS5ufPq5Tw
  door: AAABW1MY29aeIcvTEOR9kA6_y5kvw0-IFF2RrXQ1JBO7A4g
heater: AAABfNVMHuW4TGXFVtJU2eCqf_yZFQE6J3dPXknpVxJaaIY
 light: AAAB1y-EtHHv2M5SICIrrXiFP9shThBKNTVIS1ZN-S_3oeE
friend: AAABBEAPV19tXKZitG5IV8hwqWgLH8YXZN6o9d9khV4Hd1U





-- ACT 1: Devices that trust -----------------------------

# Setting devices to trust owner...

Note: for sake of simplification, we're using unlimited
      validity. You should not do that in production.

   door trust owner: "Success"
  light trust owner: "Success"
heater trusts owner: "Success"

# Listing relationships...

  door->owner: [{"target":"AAAB0ucvUnYeNvtohYhj32ZYmfUgK10YvPlgLVS5ufPq5Tw","policy":"action:{control.door}"}]
 light->owner: [{"target":"AAAB0ucvUnYeNvtohYhj32ZYmfUgK10YvPlgLVS5ufPq5Tw","policy":"action:{control.light}"}]
heater->owner: [{"target":"AAAB0ucvUnYeNvtohYhj32ZYmfUgK10YvPlgLVS5ufPq5Tw","policy":"action:{control.heating}"}]

# Exporting delegation certificates...

  door->owner: ZDI6aHRkODpTSEEyXzI1NmQzMjr1xo2RHvF2ByuY2KaQZ5dq2J2ZsvegOky0qee_ZzaiYjgxOmQzOmtleTM1OgAAAdLnL1J2Hjb7aIWIY99mWJn1ICtdGLz5YC1Uubnz6uU8NTp2YWx1ZWQxOnYyMTphY3Rpb246e2NvbnRyb2wuZG9vcn1lZWVlNTpyb290c2xkMTA6cHVibGljX2tleTM1OgAAAVtTGNvWniHL0xDkfZAOv8uZL8NPiBRdka10NSQTuwOIOTpzaWduYXR1cmUxMzQ6mUFBBSDXeHMfZQIqG5cBcpOi7tk-sUcCsKlVWrOZSbfhfpW6LynpbCkLENI4J7RQ5dsoyh5FALyNcRWcct3ICGQxOmNpMTU3NjA2MDE1MTkzM2UxOnJkODpTSEEyXzI1NjMyOvXGjZEe8XYHK5jYppBnl2rYnZmy96A6TLSp579nNqJiZWVlZWU
 light->owner: ZDI6aHRkODpTSEEyXzI1NmQzMjqDQytqVr6LTrWmz8gDzdKzwCrHL_0fSttP9zQe_hnaKzgyOmQzOmtleTM1OgAAAdLnL1J2Hjb7aIWIY99mWJn1ICtdGLz5YC1Uubnz6uU8NTp2YWx1ZWQxOnYyMjphY3Rpb246e2NvbnRyb2wubGlnaHR9ZWVlZTU6cm9vdHNsZDEwOnB1YmxpY19rZXkzNToAAAHXL4S0ce_YzlIgIiuteIU_2yFOEEo1NUhLVk35L_eh4Tk6c2lnbmF0dXJlMTM0OgOe9x1fR0PrG0pGXB_Cefhq4cfLkK1d4RkNeiBDIB5pVI5pXeL640owSFbBU8KsVFZtw-_ouNwPPsjuVEjSywBkMTpjaTE1NzYwNjAxNTIxNThlMTpyZDg6U0hBMl8yNTYzMjqDQytqVr6LTrWmz8gDzdKzwCrHL_0fSttP9zQe_hnaK2VlZWVl
heater->owner: ZDI6aHRkODpTSEEyXzI1NmQzMjq0B65brblOpYFLPiyuEZHJ1LwC4K8KwYZT6Bb_8ruzUjg0OmQzOmtleTM1OgAAAdLnL1J2Hjb7aIWIY99mWJn1ICtdGLz5YC1Uubnz6uU8NTp2YWx1ZWQxOnYyNDphY3Rpb246e2NvbnRyb2wuaGVhdGluZ31lZWVlNTpyb290c2xkMTA6cHVibGljX2tleTM1OgAAAXzVTB7luExlxVbSVNngqn_8mRUBOid3T15J6VcSWmiGOTpzaWduYXR1cmUxMzQ6y6K1lDiRvxirwt4JO5u69UHISN3HCNbQ5nrbNo24gaSVp_E37YjkPMTJrohSDdePAjWcIToDYZ3Pswqud2bkA2QxOmNpMTU3NjA2MDE1MjM2OWUxOnJkODpTSEEyXzI1NjMyOrQHrlutuU6lgUs-LK4RkcnUvALgrwrBhlPoFv_yu7NSZWVlZWU

# Verifying trust between devices and owner...

Note: This is not a cryptographic end-to-end verification
      but a global-view verification from the point of view
      of a third party. However, the principles are the same.
      For details, please check the commends in the demo script.
      For a proper cryptographic verification please take a
      look at the handshake example/

   owner can control door?: {"success":true,"policy":"action:{control.door}"}
  owner can control light?: {"success":true,"policy":"action:{control.light}"}
 owner can control heater?: {"success":true,"policy":"action:{control.heating}"}

# Verifying trust between devices and friend...

Note: the friend has no access, so everything should fail.
  friend can control door?: {"success":false,"policy":"_"}
 friend can control light?: {"success":false,"policy":"_"}
friend can control heater?: {"success":false,"policy":"_"}





-- ACT 2: Delegating some --------------------------------

# Owner delegates PARTIAL control...

door trust friend with light: "Success"

# Listing relationships of owner...

owner->friend: [{"target":"AAABBEAPV19tXKZitG5IV8hwqWgLH8YXZN6o9d9khV4Hd1U","policy":"action:{control.light}"}]

# Exporting owner delegation certificates...

owner->friend: ZDI6aHRkODpTSEEyXzI1NmQzMjoy8738_kGdZXV04pThNDeLg5ybcfNeeN3C1Aqw9PwnuTgyOmQzOmtleTM1OgAAAQRAD1dfbVymYrRuSFfIcKloCx_GF2TeqPXfZIVeB3dVNTp2YWx1ZWQxOnYyMjphY3Rpb246e2NvbnRyb2wubGlnaHR9ZWVlZTU6cm9vdHNsZDEwOnB1YmxpY19rZXkzNToAAAHS5y9Sdh42-2iFiGPfZliZ9SArXRi8-WAtVLm58-rlPDk6c2lnbmF0dXJlMTM0On7SBhfL5pxuZ_dF2wGRZrrFchB_JN8qGJ3LhzJyus96WyQ97aX-umr0qV3Ea8aRm6Ict3SLtI_w8DLhIP2t2wFkMTpjaTE1NzYwNjAxNTQ1ODRlMTpyZDg6U0hBMl8yNTYzMjoy8738_kGdZXV04pThNDeLg5ybcfNeeN3C1Aqw9PwnuWVlZWVl

# Verifying trust between devices and friend...

Note: With the additional delegation of the owner
      the friend is now able to control the light.
      But _only_ the light.

  friend can control door?: {"success":false,"policy":"_"}
 friend can control light?: {"success":true,"policy":"action:{control.light}"}
friend can control heater?: {"success":false,"policy":"_"}





-- ACT 3: Delegating all ---------------------------------

# Owner delegates FULL control...

door trust friend with light: "Success"

# Listing relationships of owner...

owner->friend: [{"target":"AAABBEAPV19tXKZitG5IV8hwqWgLH8YXZN6o9d9khV4Hd1U","policy":"action:{control}"}]

# Exporting owner delegation certificates...

owner->friend: ZDI6aHRkODpTSEEyXzI1NmQzMjobxhaJlAyTkXiEfYd6VddxzE-qEgfA8WPf3zVjqfD16zc2OmQzOmtleTM1OgAAAQRAD1dfbVymYrRuSFfIcKloCx_GF2TeqPXfZIVeB3dVNTp2YWx1ZWQxOnYxNjphY3Rpb246e2NvbnRyb2x9ZWVlZTU6cm9vdHNsZDEwOnB1YmxpY19rZXkzNToAAAHS5y9Sdh42-2iFiGPfZliZ9SArXRi8-WAtVLm58-rlPDk6c2lnbmF0dXJlMTM0OmRty0OKoLlmfvZeZPB3dOG1oSvthRCyeTnwJtNPFAXGqaQu3DeACYiTvsVmyDbctnrh0Xvos9J9klYHcbryzgpkMTpjaTE1NzYwNjAxNTU5ODZlMTpyZDg6U0hBMl8yNTYzMjobxhaJlAyTkXiEfYd6VddxzE-qEgfA8WPf3zVjqfD162VlZWVl

# Verifying trust between devices and friend...

Note: With the broader delegation of the owner
      the friend is now able to control all devices.
      And do so with a single delegation.

  friend can control door?: {"success":true,"policy":"action:{control.door}"}
 friend can control light?: {"success":true,"policy":"action:{control.light}"}
friend can control heater?: {"success":true,"policy":"action:{control.heating}"}
```
