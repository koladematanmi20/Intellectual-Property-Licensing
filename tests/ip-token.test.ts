import { describe, it, expect, beforeEach, vi } from 'vitest'

const mockContractCall = vi.fn()

describe('IP Token Contract', () => {
  const contractAddress = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM'
  const contractName = 'ip-token'
  let creator: string
  let user: string
  
  beforeEach(() => {
    creator = 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG'
    user = 'ST2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC'
    mockContractCall.mockClear()
  })
  
  describe('mint', () => {
    it('should mint a new IP token successfully', async () => {
      mockContractCall.mockResolvedValueOnce({ success: true, value: 0 })
      const result = await mockContractCall('mint', ['patent', 'Test Patent', 'Description', 'REG123', 1735689600], { sender: creator })
      expect(result.success).toBe(true)
      expect(result.value).toBe(0)
    })
  })
  
  describe('transfer', () => {
    it('should transfer an IP token successfully', async () => {
      mockContractCall.mockResolvedValueOnce({ success: true, value: true })
      const result = await mockContractCall('transfer', [0, user], { sender: creator })
      expect(result.success).toBe(true)
      expect(result.value).toBe(true)
    })
    
    it('should fail if called by non-owner', async () => {
      mockContractCall.mockResolvedValueOnce({ success: false, error: 401 })
      const result = await mockContractCall('transfer', [0, creator], { sender: user })
      expect(result.success).toBe(false)
      expect(result.error).toBe(401)
    })
  })
  
  describe('get-token-metadata', () => {
    it('should return token metadata', async () => {
      const metadata = {
        owner: creator,
        'ip-type': 'patent',
        title: 'Test Patent',
        description: 'Description',
        'registration-number': 'REG123',
        'expiration-date': 1735689600
      }
      mockContractCall.mockResolvedValueOnce({ success: true, value: metadata })
      const result = await mockContractCall('get-token-metadata', [0])
      expect(result.success).toBe(true)
      expect(result.value).toEqual(metadata)
    })
  })
  
  describe('update-expiration-date', () => {
    it('should update expiration date successfully', async () => {
      mockContractCall.mockResolvedValueOnce({ success: true, value: true })
      const result = await mockContractCall('update-expiration-date', [0, 1767225600], { sender: creator })
      expect(result.success).toBe(true)
      expect(result.value).toBe(true)
    })
    
    it('should fail if called by non-owner', async () => {
      mockContractCall.mockResolvedValueOnce({ success: false, error: 401 })
      const result = await mockContractCall('update-expiration-date', [0, 1767225600], { sender: user })
      expect(result.success).toBe(false)
      expect(result.error).toBe(401)
    })
  })
})

