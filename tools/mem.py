from random import randint
from collections import OrderedDict

# special memory-mapped IO addresses
mmio_locations = OrderedDict([
    ("IOA", 248), # toggle switches SW11-SW8
    ("IOB", 249), # toggle switches  SW7-SW0
    ("IOC", 250), # output on LED7-LED0
    ("IOD", 251), # output on LED15-LED8
    ("IOE", 252), # output on seven-segment
    ("IOF", 253), # output on seven-segment
    ("IOG", 254), # output on seven-segment
    ("IOH", 255)  # output on seven-segment
])


class Memory():
    def __init__(self, size, randomize_memory = False, use_mmio = True):
        global mmio_locations

        self.size = size
        self.mem = [0] * size
        for addr in range (size):
            self.mem[addr] = randint(-128, 128) if randomize_memory else 0
        self.use_mmio = use_mmio
        
        if (use_mmio):
            self.mem[mmio_locations["IOA"]] = 0;
            self.mem[mmio_locations["IOB"]] = 0;

    
    def loadHalfWord(self, addr):
        raise 'NYI'            
        return val

    def storeHalfWord(self, addr, val):
        raise 'NYI'            
        return 1

    def loadByte(self, addr):
        # print('LB: Addr: %d: Val: %d' % (addr, self.mem[addr]))
        if (addr >= self.size):
            print("Warning: address %d larger than memory space; translating to address %d" % (addr, addr % self.size))
            addr = addr % self.size
        val = self.mem[addr]
        return val

    def storeByte(self, addr, val):
        global mmio_locations
        
        # print('SB: Addr: %d: Val: %d' % (addr, val))
        if (addr >= self.size):
            print("Warning: address %d larger than memory space; translating to address %d" % (addr, addr % self.size))
            addr = addr % self.size
        if (self.use_mmio and (addr == mmio_locations["IOA"] or addr == mmio_locations["IOB"])):
            print("Warning: can't write to memory-mapped switches; ignoring write to address %d" % addr)
            return -1 # don't write to IO switches
        self.mem[addr] = val
        return 1
    
    def setSwitch(self, switchID, bit):
        global mmio_locations
        
        bit &= 1
        
        if (not self.use_mmio):
            return -2
        
        if (switchID < 0 or switchID > 11):
            print("Warning: switch ID %d exceeds available switches" % switchID)
            return -1
        
        setmask = 1 << (switchID % 8)
        
        addr = mmio_locations["IOB"]
        if (switchID > 7):
            addr = mmio_locations["IOA"]
        
        if(bit == 0):
            setmask = ~setmask;
        
            self.mem[addr] = self.mem[addr] & setmask
        else:
            self.mem[addr] = self.mem[addr] | setmask
        
    
    def getSwitch(self, switchID):
        global mmio_locations
        
        if (not self.use_mmio):
            return -2
        
        if (switchID < 0 or switchID > 11):
            print("Warning: switch ID %d exceeds available switches" % switchID)
            return -1
        
        if (switchID > 7):
            return (self.mem[mmio_locations["IOA"]] >> (switchID - 8)) & 1
        else:
            return (self.mem[mmio_locations["IOB"]] >> switchID) & 1
        
    
    def init_testmode(self):
        for i in range(self.size):
            self.mem[i] = i

    def dump(self):
        quarter = int(self.size/4)
        half = 2 * quarter
        half_quarter = 3 * quarter
        for i in range (quarter):
            print('MEM %d[%d (0x%x)] | MEM %d[%d (0x%x)] | MEM %d[%d (0x%x) | MEM %d[%d (0x%x)' % \
                (i, self.mem[i], self.mem[i] & 0xff,\
                i+quarter, self.mem[i+quarter], self.mem[i+quarter] & 0xff,\
                i+half, self.mem[i+half], self.mem[i+half] & 0xff,\
                i+half_quarter, self.mem[i+half_quarter], \
                self.mem[i+half_quarter] & 0xff\
                ))


if __name__ == '__main__':
    test_mem = Memory(256)
    test_mem.init_testmode()
    test_mem.dump_mem()
